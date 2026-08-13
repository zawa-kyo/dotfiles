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

// TestDotfilesApply verifies the declared links, additive directories, and idempotency.
func TestDotfilesApply(t *testing.T) {
	repo := repositoryRoot(t)
	home := t.TempDir()

	mustWriteFile(t, filepath.Join(home, ".local", "bin", "unrelated"), "user-owned\n", 0o644)
	mustWriteFile(t, filepath.Join(home, ".apm", "apm_modules", "cached", "data"), "cached\n", 0o644)

	runMise(t, repo, home, nil, "bootstrap", "dotfiles", "apply", "--yes")

	assertLink(t, filepath.Join(home, ".gitconfig"), filepath.Join(repo, "config", "tools", "git", ".gitconfig"))
	assertLink(t, filepath.Join(home, ".config", "nvim"), filepath.Join(repo, "config", "editors", "nvim"))
	assertLink(t, filepath.Join(home, ".local", "bin", "search-google"), filepath.Join(repo, "bin", "search-google"))
	assertFileContent(t, filepath.Join(home, ".local", "bin", "unrelated"), "user-owned\n")
	assertFileContent(t, filepath.Join(home, ".apm", "apm_modules", "cached", "data"), "cached\n")

	before := symlinksUnder(t, home)
	runMise(t, repo, home, nil, "bootstrap", "dotfiles", "status", "--missing")
	runMise(t, repo, home, nil, "bootstrap", "dotfiles", "apply", "--yes")
	after := symlinksUnder(t, home)
	if !reflect.DeepEqual(before, after) {
		t.Fatalf("second apply changed symlinks\nbefore: %v\nafter:  %v", before, after)
	}
}

// TestDotfileConflictSemantics verifies regular-file protection and symlink convergence.
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
		assertLink(t, target, filepath.Join(repo, "config", "editors", "nvim"))
	})
}

// TestLegacyAPMLinkMigration verifies that a dangling legacy link is migrated before apply.
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
	assertLink(t, filepath.Join(target, "apm.yml"), filepath.Join(repo, "config", "ai", "apm", "apm.yml"))
}

// TestPlatformDeclarations verifies that common config does not contain macOS targets.
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

// repositoryRoot returns the repository containing this test file.
func repositoryRoot(t *testing.T) string {
	t.Helper()
	_, filename, _, ok := runtime.Caller(0)
	if !ok {
		t.Fatal("resolve test file path")
	}
	return filepath.Dir(filepath.Dir(filename))
}

// runMise runs mise and fails with its combined diagnostic output.
func runMise(t *testing.T, repo, home string, env map[string]string, args ...string) string {
	t.Helper()
	command := miseCommand(repo, home, env, args...)
	output, err := command.CombinedOutput()
	if err != nil {
		t.Fatalf("mise %s failed: %v\n%s", strings.Join(args, " "), err, output)
	}
	return string(output)
}

// miseCommand creates an isolated mise process for one temporary home directory.
func miseCommand(repo, home string, env map[string]string, args ...string) *exec.Cmd {
	command := exec.Command("mise", args...)
	command.Dir = repo
	values := map[string]string{
		"HOME":                      home,
		"MISE_GLOBAL_CONFIG_FILE":   filepath.Join(home, "global-mise.toml"),
		"MISE_TRUSTED_CONFIG_PATHS": repo,
	}
	for key, value := range env {
		values[key] = value
	}
	command.Env = replaceEnvironment(os.Environ(), values)
	return command
}

// replaceEnvironment replaces selected variables without keeping duplicate entries.
func replaceEnvironment(base []string, replacements map[string]string) []string {
	result := make([]string, 0, len(base)+len(replacements))
	for _, entry := range base {
		key, _, found := strings.Cut(entry, "=")
		if found {
			if _, replaced := replacements[key]; replaced {
				continue
			}
		}
		result = append(result, entry)
	}
	for key, value := range replacements {
		result = append(result, key+"="+value)
	}
	return result
}

// mustWriteFile creates a fixture file and its parent directories.
func mustWriteFile(t *testing.T, path, content string, mode os.FileMode) {
	t.Helper()
	if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
		t.Fatalf("create fixture directory: %v", err)
	}
	if err := os.WriteFile(path, []byte(content), mode); err != nil {
		t.Fatalf("write fixture %s: %v", path, err)
	}
}

// mustSymlink creates a fixture symlink and its parent directories.
func mustSymlink(t *testing.T, source, target string) {
	t.Helper()
	if err := os.MkdirAll(filepath.Dir(target), 0o755); err != nil {
		t.Fatalf("create symlink parent: %v", err)
	}
	if err := os.Symlink(source, target); err != nil {
		t.Fatalf("create symlink %s: %v", target, err)
	}
}

// assertLink verifies an exact symlink source.
func assertLink(t *testing.T, path, expected string) {
	t.Helper()
	actual, err := os.Readlink(path)
	if err != nil {
		t.Fatalf("read symlink %s: %v", path, err)
	}
	if actual != expected {
		t.Fatalf("%s points to %s, want %s", path, actual, expected)
	}
}

// assertFileContent verifies that user-owned or generated data remains unchanged.
func assertFileContent(t *testing.T, path, expected string) {
	t.Helper()
	content, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("read %s: %v", path, err)
	}
	if string(content) != expected {
		t.Fatalf("%s contains %q, want %q", path, content, expected)
	}
}

// symlinksUnder records relative paths and sources for an idempotency comparison.
func symlinksUnder(t *testing.T, root string) map[string]string {
	t.Helper()
	links := make(map[string]string)
	err := filepath.WalkDir(root, func(path string, entry os.DirEntry, walkErr error) error {
		if walkErr != nil {
			return walkErr
		}
		if entry.Type()&os.ModeSymlink == 0 {
			return nil
		}
		source, err := os.Readlink(path)
		if err != nil {
			return err
		}
		relative, err := filepath.Rel(root, path)
		if err != nil {
			return err
		}
		links[relative] = source
		return nil
	})
	if err != nil {
		t.Fatalf("record symlinks: %v", err)
	}
	return links
}
