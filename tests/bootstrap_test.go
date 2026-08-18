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

	runMise(t, repo, home, nil, "bootstrap", "dotfiles", "apply", "--yes")

	assertLink(t, filepath.Join(home, ".gitconfig"), filepath.Join(repo, "dotfiles", "tools", "git", ".gitconfig"))
	assertLink(t, filepath.Join(home, ".config", "nvim"), filepath.Join(repo, "dotfiles", "editors", "nvim"))
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

	before := symlinksUnder(t, home)
	runMise(t, repo, home, nil, "bootstrap", "dotfiles", "status", "--missing")
	runMise(t, repo, home, nil, "bootstrap", "dotfiles", "apply", "--yes")
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
	runMise(t, repo, home, nil, "bootstrap", "dotfiles", "apply", "--yes")
	mustWriteFile(t, lockFile, "user-modified\n", 0o644)

	if output, err := miseCommand(repo, home, nil, "bootstrap", "dotfiles", "unapply", "--yes").CombinedOutput(); err == nil {
		t.Fatalf("unapply unexpectedly removed a modified copy:\n%s", output)
	}
	assertLink(t, gitConfig, filepath.Join(repo, "dotfiles", "tools", "git", ".gitconfig"))
	assertFileContent(t, lockFile, "user-modified\n")

	sourceLock, err := os.ReadFile(filepath.Join(repo, "dotfiles", "ai", "apm", "apm.lock.yaml"))
	if err != nil {
		t.Fatalf("read source APM lock: %v", err)
	}
	mustWriteFile(t, lockFile, string(sourceLock), 0o644)
	runMise(t, repo, home, nil, "bootstrap", "dotfiles", "unapply", "--dry-run")
	runMise(t, repo, home, nil, "bootstrap", "dotfiles", "unapply", "--yes")

	if _, err := os.Lstat(gitConfig); !os.IsNotExist(err) {
		t.Fatalf("managed symlink remains after unapply: %v", err)
	}
	if _, err := os.Lstat(filepath.Join(home, ".local", "bin", "search-google")); !os.IsNotExist(err) {
		t.Fatalf("managed symlink-each entry remains after unapply: %v", err)
	}
	assertFileContent(t, unrelated, "user-owned\n")
	assertFileContent(t, generated, "cached\n")
	if _, err := os.Lstat(lockFile); !os.IsNotExist(err) {
		t.Fatalf("managed copy remains after unapply: %v", err)
	}

	runMise(t, repo, home, nil, "bootstrap", "dotfiles", "apply", "~/.gitconfig", "--yes")
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

	runMise(t, repo, home, nil, "bootstrap", "dotfiles", "apply", "--yes")
	assertLinkResolves(t, targetLock, sourceLock)

	mustWriteFile(t, filepath.Join(repo, "mise.toml"), `[dotfiles]
"~/.apm" = { source = "dotfiles/ai/apm", mode = "symlink-each", exclude = ["apm.lock.yaml"] }
"~/.apm/apm.lock.yaml" = { source = "dotfiles/ai/apm/apm.lock.yaml", mode = "copy" }
`, 0o644)
	runMise(t, repo, home, nil, "bootstrap", "dotfiles", "apply", "--yes")
	assertRegularFile(t, targetLock)

	mustWriteFile(t, targetLock, "version: new\n", 0o644)
	runMise(t, repo, home, nil, "bootstrap", "dotfiles", "add", "--yes", "~/.apm/apm.lock.yaml")
	assertFileContent(t, sourceLock, "version: new\n")
	runMise(t, repo, home, nil, "bootstrap", "dotfiles", "status", "--missing")
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
		"PATH":                   fakeBin + string(os.PathListSeparator) + os.Getenv("PATH"),
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

		if output, err := miseCommand(repo, home, nil, "bootstrap", "dotfiles", "apply", "~/.gitconfig", "--yes").CombinedOutput(); err == nil {
			t.Fatalf("apply unexpectedly replaced a regular file:\n%s", output)
		}
		assertFileContent(t, target, "user-owned\n")
	})

	t.Run("symlink converges to declared source", func(t *testing.T) {
		home := t.TempDir()
		target := filepath.Join(home, ".config", "nvim")
		mustSymlink(t, t.TempDir(), target)

		runMise(t, repo, home, nil, "bootstrap", "dotfiles", "apply", "~/.config/nvim", "--yes")
		assertLink(t, target, filepath.Join(repo, "dotfiles", "editors", "nvim"))
	})
}

// A dangling legacy APM link migrates before dotfiles are applied.
func TestLegacyAPMLinkMigration(t *testing.T) {
	repo := repositoryRoot(t)
	home := t.TempDir()
	target := filepath.Join(home, ".apm")
	mustSymlink(t, filepath.Join(repo, "packages", "apm"), target)

	runMise(t, repo, home, nil, "bootstrap", "dotfiles", "apply", "~/.apm", "--yes")

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
	output := runMise(t, repo, home, map[string]string{"MISE_AUTO_ENV": "false"}, "bootstrap", "dotfiles", "status", "--json")

	var status dotfilesStatus
	if err := json.Unmarshal([]byte(output), &status); err != nil {
		t.Fatalf("decode dotfiles status: %v\n%s", err, output)
	}
	for _, file := range status.Files {
		if strings.Contains(file.Target, "Library/") {
			t.Fatalf("common declarations contain a macOS target: %s", file.Target)
		}
	}

	if runtime.GOOS == "darwin" {
		platformOutput := runMise(t, repo, home, nil, "bootstrap", "dotfiles", "status", "--json")
		if !strings.Contains(platformOutput, "Library/Application Support/Code/User/settings.json") {
			t.Fatal("macOS declarations were not loaded")
		}
	}
}

// Bootstrap leaves Homebrew installation behind an explicit task.
func TestBootstrapExcludesHomebrewInstall(t *testing.T) {
	if runtime.GOOS != "darwin" {
		t.Skip("Homebrew task is declared only on macOS")
	}

	repo := repositoryRoot(t)
	home := t.TempDir()
	output := runMise(t, repo, home, nil, "bootstrap", "--dry-run", "--yes")
	if strings.Contains(output, "install-brew") || strings.Contains(output, "brew bundle install") {
		t.Fatalf("bootstrap unexpectedly includes Homebrew installation:\n%s", output)
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
			return
		}
	}
	t.Fatalf("explicit Homebrew install task is missing:\n%s", tasks)
}

// Bootstrap installs a mise entrypoint for Lefthook without Python tooling.
func TestBootstrapInstallsMisePreCommitHook(t *testing.T) {
	repo := repositoryRoot(t)
	home := t.TempDir()
	output := runMise(t, repo, home, nil, "bootstrap", "--dry-run", "--yes")

	if !strings.Contains(output, "install-git-hooks") || !strings.Contains(output, "mise generate git-pre-commit --write --task=pre-commit") {
		t.Fatalf("bootstrap does not install the mise pre-commit hook:\n%s", output)
	}
	preCommitOutput := runMise(t, repo, home, nil, "run", "--dry-run", "pre-commit")
	if !strings.Contains(preCommitOutput, "lefthook run pre-commit") {
		t.Fatalf("mise pre-commit task does not run Lefthook:\n%s", preCommitOutput)
	}
	for _, unexpected := range []string{"lefthook install", "install-pre-commit", "uv sync", "pre_commit"} {
		if strings.Contains(output, unexpected) {
			t.Fatalf("bootstrap contains obsolete pre-commit tooling %q:\n%s", unexpected, output)
		}
	}
}
