package bootstrap_test

import (
	"encoding/json"
	"os"
	"os/exec"
	"path/filepath"
	"reflect"
	"runtime"
	"strings"
	"testing"
)

type dotfilesStatus struct {
	Files []struct {
		Target string `json:"target"`
	} `json:"files"`
}

// Declared links preserve additive directories and remain idempotent.
func TestDotfilesApply(t *testing.T) {
	repo := repositoryRoot(t)
	home := t.TempDir()

	mustWriteFile(t, filepath.Join(home, ".local", "bin", "unrelated"), "user-owned\n", 0o644)
	mustWriteFile(t, filepath.Join(home, ".apm", "apm_modules", "cached", "data"), "cached\n", 0o644)

	runDotfiles(t, repo, home, nil, "apply", "--yes")

	assertLink(t, filepath.Join(home, ".gitconfig"), filepath.Join(repo, "dotfiles", "tools", "git", ".gitconfig"))
	assertLink(t, filepath.Join(home, ".config", "nvim"), filepath.Join(repo, "dotfiles", "editors", "nvim"))
	assertLink(t, filepath.Join(home, ".config", "mise", "miserc.toml"), filepath.Join(repo, ".miserc.toml"))
	assertLink(t, filepath.Join(home, ".local", "bin", "search-google"), filepath.Join(repo, "bin", "search-google"))
	assertRegularFile(t, filepath.Join(home, ".apm", "apm.lock.yaml"))
	assertFileContent(t, filepath.Join(home, ".local", "bin", "unrelated"), "user-owned\n")
	assertFileContent(t, filepath.Join(home, ".apm", "apm_modules", "cached", "data"), "cached\n")

	configCommand := exec.Command("mise", "config", "ls")
	configCommand.Dir = home
	configCommand.Env = replaceEnvironment(
		environmentWithout(os.Environ(), "MISE_GLOBAL_CONFIG_FILE"),
		isolatedMiseEnvironment(repo, home),
	)

	configOutputBytes, err := configCommand.CombinedOutput()

	if err != nil {
		t.Fatalf("load linked global mise configuration: %v\n%s", err, configOutputBytes)
	}
	configOutput := string(configOutputBytes)
	if !strings.Contains(configOutput, filepath.Join(home, ".config", "mise", "conf.d", "tools.toml")) {
		t.Fatalf("linked global mise configuration was not loaded:\n%s", configOutput)
	}
	assertPlatformDotfiles(t, repo, home, configOutput)

	envCommand := exec.Command("mise", "env", "--json")
	envCommand.Dir = home
	envCommand.Env = replaceEnvironment(
		environmentWithout(os.Environ(), "MISE_GLOBAL_CONFIG_FILE"),
		isolatedMiseEnvironment(repo, home),
	)

	envOutput, err := envCommand.Output()

	if err != nil {
		t.Fatalf("load linked global mise environment: %v", err)
	}
	var linkedEnv map[string]string
	if err := json.Unmarshal(envOutput, &linkedEnv); err != nil {
		t.Fatalf("decode linked global mise environment: %v\n%s", err, envOutput)
	}
	_, hasChromeBookmarks := linkedEnv["CHROME_BOOKMARKS_ROOT"]
	if runtime.GOOS == "darwin" && !hasChromeBookmarks {
		t.Fatal("macOS bookmark environment was not loaded")
	}
	if runtime.GOOS != "darwin" && hasChromeBookmarks {
		t.Fatal("macOS bookmark environment was loaded outside macOS")
	}
	linkedPath := linkedEnv["PATH"]
	if !strings.Contains(linkedPath, filepath.Join(home, ".local", "bin")) {
		t.Fatalf("common PATH entries were not loaded: %s", linkedPath)
	}
	macOSPath := filepath.Join(home, "Library", "Android", "sdk", "platform-tools")
	if runtime.GOOS == "darwin" && !strings.Contains(linkedPath, macOSPath) {
		t.Fatalf("macOS PATH entries were not loaded: %s", linkedPath)
	}
	if runtime.GOOS != "darwin" && strings.Contains(linkedPath, macOSPath) {
		t.Fatalf("macOS PATH entries were loaded outside macOS: %s", linkedPath)
	}

	before := symlinksUnder(t, home)

	runDotfiles(t, repo, home, nil, "status", "--missing")
	runDotfiles(t, repo, home, nil, "apply", "--yes")
	after := symlinksUnder(t, home)

	if !reflect.DeepEqual(before, after) {
		t.Fatalf("second apply changed symlinks\nbefore: %v\nafter:  %v", before, after)
	}
}

// Unapply removes identifiable managed files and preserves neighboring user data.
func TestDotfilesUnapply(t *testing.T) {
	repo := repositoryRoot(t)
	home := t.TempDir()
	unrelated := filepath.Join(home, ".local", "bin", "unrelated")
	generated := filepath.Join(home, ".apm", "apm_modules", "cached", "data")
	lockFile := filepath.Join(home, ".apm", "apm.lock.yaml")
	gitConfig := filepath.Join(home, ".gitconfig")

	mustWriteFile(t, unrelated, "user-owned\n", 0o644)
	mustWriteFile(t, generated, "cached\n", 0o644)
	runDotfiles(t, repo, home, nil, "apply", "--yes")
	mustWriteFile(t, lockFile, "user-modified\n", 0o644)

	output, err := dotfilesCommand(repo, home, nil, "unapply", "--yes").CombinedOutput()

	if err == nil {
		t.Fatalf("unapply unexpectedly removed a modified copy:\n%s", output)
	}
	assertLink(t, gitConfig, filepath.Join(repo, "dotfiles", "tools", "git", ".gitconfig"))
	assertFileContent(t, lockFile, "user-modified\n")

	sourceLock, err := os.ReadFile(filepath.Join(repo, "dotfiles", "ai", "apm", "apm.lock.yaml"))
	if err != nil {
		t.Fatalf("read source APM lock: %v", err)
	}
	mustWriteFile(t, lockFile, string(sourceLock), 0o644)

	runDotfiles(t, repo, home, nil, "unapply", "--dry-run")
	runDotfiles(t, repo, home, nil, "unapply", "--yes")

	assertPathMissing(t, gitConfig)
	assertPathMissing(t, filepath.Join(home, ".local", "bin", "search-google"))
	assertFileContent(t, unrelated, "user-owned\n")
	assertFileContent(t, generated, "cached\n")
	assertPathMissing(t, lockFile)

	runDotfiles(t, repo, home, nil, "apply", "~/.gitconfig", "--yes")

	assertLink(t, gitConfig, filepath.Join(repo, "dotfiles", "tools", "git", ".gitconfig"))
}

// An APM lock migrates from symlink-each and returns to the repository after an update.
func TestAPMLockCopyRoundTrip(t *testing.T) {
	repo := t.TempDir()
	home := t.TempDir()
	sourceDir := filepath.Join(repo, "dotfiles", "ai", "apm")
	targetLock := filepath.Join(home, ".apm", "apm.lock.yaml")
	sourceLock := filepath.Join(sourceDir, "apm.lock.yaml")

	mustWriteFile(t, filepath.Join(sourceDir, "apm.yml"), "dependencies: {}\n", 0o644)
	mustWriteFile(t, filepath.Join(sourceDir, "config.json"), "{}\n", 0o644)
	mustWriteFile(t, sourceLock, "version: old\n", 0o644)
	mustWriteFile(t, filepath.Join(repo, "mise.toml"), `[dotfiles]
"~/.apm" = { source = "dotfiles/ai/apm", mode = "symlink-each" }
`, 0o644)

	runDotfiles(t, repo, home, nil, "apply", "--yes")

	assertLinkResolves(t, targetLock, sourceLock)

	mustWriteFile(t, filepath.Join(repo, "mise.toml"), `[dotfiles]
"~/.apm" = { source = "dotfiles/ai/apm", mode = "symlink-each", exclude = ["apm.lock.yaml"] }
"~/.apm/apm.lock.yaml" = { source = "dotfiles/ai/apm/apm.lock.yaml", mode = "copy" }
`, 0o644)

	runDotfiles(t, repo, home, nil, "apply", "--yes")

	assertRegularFile(t, targetLock)

	mustWriteFile(t, targetLock, "version: new\n", 0o644)

	runDotfiles(t, repo, home, nil, "add", "--yes", "~/.apm/apm.lock.yaml")

	assertFileContent(t, sourceLock, "version: new\n")
	runDotfiles(t, repo, home, nil, "status", "--missing")
}

// The production APM task captures the lock only after completing its update.
func TestAPMUpgradeCapturesLockFile(t *testing.T) {
	repo := repositoryRoot(t)
	home := t.TempDir()

	output := runMise(t, repo, home, nil, "run", "--dry-run", "upgrade-apm")

	previous := -1
	for _, expected := range []string{
		"mise -C ~ install apm",
		"mise -C ~ exec -- apm update -g --yes",
		"mise bootstrap dotfiles add --yes ~/.apm/apm.lock.yaml",
	} {
		position := strings.Index(output, expected)
		if position <= previous {
			t.Fatalf("upgrade-apm does not run %q in order:\n%s", expected, output)
		}
		previous = position
	}
}

// Each wrapper delegates to its intended public behavior.
func TestPublishedCommandWrappers(t *testing.T) {
	repo := repositoryRoot(t)
	fakeBin := t.TempDir()
	home := t.TempDir()
	chromeRoot := filepath.Join(home, "Chrome")
	safariPlist := filepath.Join(home, "Safari", "Bookmarks.plist")
	mustWriteFile(t, filepath.Join(fakeBin, "procs"), "#!/bin/sh\nprintf 'PID CPU\\n-- ---\\n1 1\\n'\n", 0o755)
	mustWriteFile(t, filepath.Join(fakeBin, "plutil"), `#!/bin/sh
printf '%s\n' '{"Children":[{"WebBookmarkType":"WebBookmarkTypeLeaf","URIDictionary":{"title":"Safari Example"},"URLString":"https://safari.example"}]}'
`, 0o755)
	mustWriteFile(t, filepath.Join(chromeRoot, "Default", "Bookmarks"), `{"roots":{"bookmark_bar":{"children":[{"type":"url","name":"Chrome Example","url":"https://chrome.example"}]}}}
`, 0o644)
	mustWriteFile(t, safariPlist, "fixture\n", 0o644)
	env := map[string]string{
		"CHROME_BOOKMARKS_ROOT":  chromeRoot,
		"HOME":                   home,
		"PATH":                   pathWithPrefix(fakeBin),
		"SAFARI_BOOKMARKS_PLIST": safariPlist,
	}

	tests := []struct {
		name     string
		args     []string
		expected string
	}{
		{name: "reveal-process-cpu", expected: "processes by CPU usage"},
		{name: "reveal-process-memory", expected: "processes by memory usage"},
		{name: "search-bookmarks-chrome", args: []string{"--dump"}, expected: "Chrome\tDefault\tChrome Example\thttps://chrome.example"},
		{name: "search-bookmarks-safari", args: []string{"--dump"}, expected: "Safari\tBookmarks\tSafari Example\thttps://safari.example"},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			output := runCommand(t, repo, env, filepath.Join(repo, "bin", test.name), test.args...)

			if !strings.Contains(output, test.expected) {
				t.Fatalf("%s output does not contain %q:\n%s", test.name, test.expected, output)
			}
		})
	}
}

// Regular files remain protected while symlinks converge to their declarations.
func TestDotfileConflictSemantics(t *testing.T) {
	repo := repositoryRoot(t)

	t.Run("regular file remains untouched", func(t *testing.T) {
		home := t.TempDir()
		target := filepath.Join(home, ".gitconfig")
		mustWriteFile(t, target, "user-owned\n", 0o644)

		output, err := dotfilesCommand(repo, home, nil, "apply", "~/.gitconfig", "--yes").CombinedOutput()

		if err == nil {
			t.Fatalf("apply unexpectedly replaced a regular file:\n%s", output)
		}
		assertFileContent(t, target, "user-owned\n")
	})

	t.Run("symlink converges to declared source", func(t *testing.T) {
		home := t.TempDir()
		target := filepath.Join(home, ".config", "nvim")
		mustSymlink(t, t.TempDir(), target)

		runDotfiles(t, repo, home, nil, "apply", "~/.config/nvim", "--yes")

		assertLink(t, target, filepath.Join(repo, "dotfiles", "editors", "nvim"))
	})
}

// A dangling legacy APM link migrates before dotfiles are applied.
func TestLegacyAPMLinkMigration(t *testing.T) {
	repo := repositoryRoot(t)
	home := t.TempDir()
	target := filepath.Join(home, ".apm")
	mustSymlink(t, filepath.Join(repo, "packages", "apm"), target)

	runDotfiles(t, repo, home, nil, "apply", "~/.apm", "--yes")

	info, err := os.Lstat(target)
	if err != nil {
		t.Fatalf("stat migrated APM directory: %v", err)
	}
	if !info.IsDir() || info.Mode()&os.ModeSymlink != 0 {
		t.Fatalf("APM target is not a real directory: %s", target)
	}
	assertLink(t, filepath.Join(target, "apm.yml"), filepath.Join(repo, "dotfiles", "ai", "apm", "apm.yml"))
}

// Common declarations exclude macOS targets while the platform config includes them.
func TestPlatformDeclarations(t *testing.T) {
	repo := repositoryRoot(t)
	home := t.TempDir()

	output := runDotfiles(t, repo, home, map[string]string{"MISE_AUTO_ENV": "false"}, "status", "--json")

	var status dotfilesStatus
	if err := json.Unmarshal([]byte(output), &status); err != nil {
		t.Fatalf("decode dotfiles status: %v\n%s", err, output)
	}
	for _, file := range status.Files {
		if strings.Contains(file.Target, "Library/") {
			t.Fatalf("common declarations contain a macOS target: %s", file.Target)
		}
	}

	if runtime.GOOS != "darwin" {
		return
	}

	platformOutput := runDotfiles(t, repo, home, nil, "status", "--json")

	if !strings.Contains(platformOutput, "Library/Application Support/Code/User/settings.json") {
		t.Fatal("macOS declarations were not loaded")
	}
}

// Verify that only macOS deploys and loads platform-specific dotfiles.
func assertPlatformDotfiles(t *testing.T, repo, home, configOutput string) {
	t.Helper()
	macOSConfig := filepath.Join(home, ".config", "mise", "config.macos.toml")
	karabinerConfig := filepath.Join(home, ".config", "karabiner", "karabiner.json")

	if runtime.GOOS != "darwin" {
		assertPathMissing(t, macOSConfig)
		assertPathMissing(t, karabinerConfig)
		return
	}

	assertLink(t, macOSConfig, filepath.Join(repo, "dotfiles", "tools", "mise", "config.macos.toml"))
	assertLink(t, karabinerConfig, filepath.Join(repo, "dotfiles", "tools", "karabiner", "karabiner.json"))
	if !strings.Contains(configOutput, macOSConfig) {
		t.Fatalf("linked macOS mise configuration was not loaded:\n%s", configOutput)
	}
}

// Bootstrap leaves Homebrew installation behind an explicit task.
func TestBootstrapExcludesHomebrewInstall(t *testing.T) {
	repo := repositoryRoot(t)
	home := t.TempDir()

	output := runMise(t, repo, home, map[string]string{"MISE_AUTO_ENV": "false"}, "bootstrap", "--dry-run", "--yes")

	if strings.Contains(output, "install-brew") || strings.Contains(output, "brew bundle install") {
		t.Fatalf("bootstrap unexpectedly includes Homebrew installation:\n%s", output)
	}

	upgradeOutput := runMise(t, repo, home, map[string]string{"MISE_AUTO_ENV": "false"}, "run", "--dry-run", "upgrade")

	if strings.Contains(upgradeOutput, "upgrade-brew") || strings.Contains(upgradeOutput, "brew upgrade") {
		t.Fatalf("common upgrade unexpectedly includes Homebrew:\n%s", upgradeOutput)
	}

	if runtime.GOOS != "darwin" {
		return
	}

	tasks := runMise(t, repo, home, nil, "tasks", "--json")

	var taskList []struct {
		Name string `json:"name"`
	}
	if err := json.Unmarshal([]byte(tasks), &taskList); err != nil {
		t.Fatalf("decode mise task list: %v\n%s", err, tasks)
	}
	for _, task := range taskList {
		if task.Name == "install-brew" {
			platformUpgradeOutput := runMise(t, repo, home, nil, "run", "--dry-run", "upgrade")

			if !strings.Contains(platformUpgradeOutput, "upgrade-brew") || !strings.Contains(platformUpgradeOutput, "brew upgrade") {
				t.Fatalf("macOS upgrade does not include Homebrew:\n%s", platformUpgradeOutput)
			}
			return
		}
	}
	t.Fatalf("explicit Homebrew install task is missing:\n%s", tasks)
}

// Bootstrap relies on the deployed Git configuration instead of mutating hook state.
func TestBootstrapUsesDeclarativeHkHook(t *testing.T) {
	repo := repositoryRoot(t)
	home := t.TempDir()

	output := runMise(t, repo, home, nil, "bootstrap", "--dry-run", "--yes")

	if !strings.Contains(output, "dotfiles") {
		t.Fatalf("bootstrap does not deploy the Git configuration:\n%s", output)
	}
	for _, unexpected := range []string{"install-git-hooks", "hk install", "lefthook", "pre_commit"} {
		if strings.Contains(output, unexpected) {
			t.Fatalf("bootstrap imperatively installs obsolete hook tooling %q:\n%s", unexpected, output)
		}
	}
}

// The global hk hook resolves standalone mise without relying on the shell PATH.
func TestHkHookFindsStandaloneMiseWithoutPath(t *testing.T) {
	repo := repositoryRoot(t)
	home := t.TempDir()
	outputPath := filepath.Join(home, "mise-output")
	configPath := filepath.Join(repo, "dotfiles", "tools", "git", ".gitconfig")

	command := exec.Command("git", "config", "--file", configPath, "--get", "hook.hk-pre-commit.command")
	hookCommand, err := command.Output()
	if err != nil {
		t.Fatalf("read hk hook command: %v", err)
	}
	mustWriteFile(t, filepath.Join(home, ".local", "bin", "mise"), "#!/bin/sh\nprintf '%s\\n' \"$@\" >\"$HOOK_OUTPUT\"\n", 0o755)

	hook := exec.Command("/bin/sh", "-c", strings.TrimSpace(string(hookCommand)))
	hook.Dir = repo
	hook.Env = []string{
		"HOME=" + home,
		"HOOK_OUTPUT=" + outputPath,
		"PATH=/usr/bin:/bin",
	}
	if output, err := hook.CombinedOutput(); err != nil {
		t.Fatalf("run pre-commit hook with restricted PATH: %v\n%s", err, output)
	}

	output, err := os.ReadFile(outputPath)
	if err != nil {
		t.Fatalf("read fake mise output: %v", err)
	}
	if string(output) != "x\nhk\n--\nhk\nrun\npre-commit\n--from-hook\n--staged\n" {
		t.Fatalf("pre-commit invoked standalone mise with unexpected arguments:\n%s", output)
	}
}
