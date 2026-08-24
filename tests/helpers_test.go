package bootstrap_test

import (
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"
	"testing"
)

// Resolve the repository containing the test package.
func repositoryRoot(t *testing.T) string {
	t.Helper()
	_, filename, _, ok := runtime.Caller(0)
	if !ok {
		t.Fatal("resolve test file path")
	}
	return filepath.Dir(filepath.Dir(filename))
}

// Run mise and report its combined diagnostic output on failure.
func runMise(t *testing.T, repo, home string, env map[string]string, args ...string) string {
	t.Helper()
	command := miseCommand(repo, home, env, args...)
	output, err := command.CombinedOutput()
	if err != nil {
		t.Fatalf("mise %s failed: %v\n%s", strings.Join(args, " "), err, output)
	}
	return string(output)
}

// Run a mise dotfiles command with the shared bootstrap prefix.
func runDotfiles(t *testing.T, repo, home string, env map[string]string, args ...string) string {
	t.Helper()
	return runMise(t, repo, home, env, append([]string{"bootstrap", "dotfiles"}, args...)...)
}

// Create a mise process isolated to one temporary home directory.
func miseCommand(repo, home string, env map[string]string, args ...string) *exec.Cmd {
	command := exec.Command("mise", args...)
	command.Dir = repo
	values := isolatedMiseEnvironment(repo, home)
	values["MISE_GLOBAL_CONFIG_FILE"] = filepath.Join(home, "global-mise.toml")
	for key, value := range env {
		values[key] = value
	}
	command.Env = replaceEnvironment(os.Environ(), values)
	return command
}

// Create a mise dotfiles process with the shared bootstrap prefix.
func dotfilesCommand(repo, home string, env map[string]string, args ...string) *exec.Cmd {
	return miseCommand(repo, home, env, append([]string{"bootstrap", "dotfiles"}, args...)...)
}

// Keep all mise state inside the temporary home.
func isolatedMiseEnvironment(repo, home string) map[string]string {
	return map[string]string{
		"HOME":                      home,
		"MISE_CACHE_DIR":            filepath.Join(home, ".cache", "mise"),
		"MISE_CONFIG_DIR":           filepath.Join(home, ".config", "mise"),
		"MISE_DATA_DIR":             filepath.Join(home, ".local", "share", "mise"),
		"MISE_STATE_DIR":            filepath.Join(home, ".local", "state", "mise"),
		"MISE_TRUSTED_CONFIG_PATHS": repo,
	}
}

// Replace selected variables without retaining duplicate entries.
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

// Remove variables that would bypass isolated defaults.
func environmentWithout(base []string, keys ...string) []string {
	removed := make(map[string]struct{}, len(keys))
	for _, key := range keys {
		removed[key] = struct{}{}
	}
	result := make([]string, 0, len(base))
	for _, entry := range base {
		key, _, found := strings.Cut(entry, "=")
		if found {
			if _, remove := removed[key]; remove {
				continue
			}
		}
		result = append(result, entry)
	}
	return result
}

// Prepend one directory to the current process PATH.
func pathWithPrefix(directory string) string {
	return directory + string(os.PathListSeparator) + os.Getenv("PATH")
}

// Create a fixture file and its parent directories.
func mustWriteFile(t *testing.T, path, content string, mode os.FileMode) {
	t.Helper()
	if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
		t.Fatalf("create fixture directory: %v", err)
	}
	if err := os.WriteFile(path, []byte(content), mode); err != nil {
		t.Fatalf("write fixture %s: %v", path, err)
	}
}

// Create a fixture symlink and its parent directories.
func mustSymlink(t *testing.T, source, target string) {
	t.Helper()
	if err := os.MkdirAll(filepath.Dir(target), 0o755); err != nil {
		t.Fatalf("create symlink parent: %v", err)
	}
	if err := os.Symlink(source, target); err != nil {
		t.Fatalf("create symlink %s: %v", target, err)
	}
}

// Compare a symlink with its exact source.
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

// Require a real file rather than a symlink.
func assertRegularFile(t *testing.T, path string) {
	t.Helper()
	info, err := os.Lstat(path)
	if err != nil {
		t.Fatalf("stat regular file %s: %v", path, err)
	}
	if !info.Mode().IsRegular() {
		t.Fatalf("%s is not a regular file: %s", path, info.Mode())
	}
}

// Compare a fixture's complete file content.
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

// Require a path to remain absent.
func assertPathMissing(t *testing.T, path string) {
	t.Helper()
	_, err := os.Lstat(path)
	if err == nil {
		t.Fatalf("path exists: %s", path)
	}
	if !os.IsNotExist(err) {
		t.Fatalf("stat missing path %s: %v", path, err)
	}
}

// Compare canonical targets across platform path aliases.
func assertLinkResolves(t *testing.T, path string, expected string) {
	t.Helper()
	actualTarget, err := filepath.EvalSymlinks(path)
	if err != nil {
		t.Fatalf("resolve symlink %s: %v", path, err)
	}
	expectedTarget, err := filepath.EvalSymlinks(expected)
	if err != nil {
		t.Fatalf("resolve expected path %s: %v", expected, err)
	}
	if actualTarget != expectedTarget {
		t.Fatalf("symlink %s resolves to %s, want %s", path, actualTarget, expectedTarget)
	}
}

// Run a repository helper with controlled environment variables.
func runCommand(t *testing.T, workingDirectory string, env map[string]string, name string, args ...string) string {
	t.Helper()
	command := exec.Command(name, args...)
	command.Dir = workingDirectory
	command.Env = replaceEnvironment(os.Environ(), env)
	output, err := command.CombinedOutput()
	if err != nil {
		t.Fatalf("%s failed: %v\n%s", name, err, output)
	}
	return string(output)
}

// Record relative symlink paths and sources for an idempotency comparison.
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
