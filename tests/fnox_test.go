package bootstrap_test

import (
	"os"
	"os/exec"
	"path/filepath"
	"testing"
)

// Initialization preserves generated files across reruns and rejects a missing key.
func TestFnoxInitialization(t *testing.T) {
	if _, err := exec.LookPath("age-keygen"); err != nil {
		t.Skip("age-keygen is required")
	}
	repo := repositoryRoot(t)
	dir := t.TempDir()
	env := map[string]string{"FNOX_CONFIG_DIR": dir}
	script := filepath.Join(repo, "setup", "init-fnox.sh")
	runCommand(t, repo, env, "bash", script)

	configPath := filepath.Join(dir, "config.toml")
	keyPath := filepath.Join(dir, "age.txt")
	config, err := os.ReadFile(configPath)
	if err != nil {
		t.Fatal(err)
	}
	key, err := os.ReadFile(keyPath)
	if err != nil {
		t.Fatal(err)
	}
	for path, mode := range map[string]os.FileMode{dir: 0o700, configPath: 0o600, keyPath: 0o600} {
		info, err := os.Stat(path)
		if err != nil || info.Mode().Perm() != mode {
			t.Fatalf("unexpected permissions for %s (stat error: %v)", path, err)
		}
	}
	runCommand(t, repo, env, "bash", script)
	assertFileContent(t, configPath, string(config))
	assertFileContent(t, keyPath, string(key))

	if err := os.Remove(keyPath); err != nil {
		t.Fatal(err)
	}
	command := exec.Command("bash", script)
	command.Env = replaceEnvironment(os.Environ(), env)
	if err := command.Run(); err == nil {
		t.Fatal("initialization unexpectedly succeeded without the original key")
	}
	assertPathMissing(t, keyPath)
	assertFileContent(t, configPath, string(config))
}
