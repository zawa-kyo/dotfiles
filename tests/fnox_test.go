package bootstrap_test

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
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

// Configuration directory overrides follow fnox's precedence.
func TestFnoxConfigDirectory(t *testing.T) {
	if _, err := exec.LookPath("age-keygen"); err != nil {
		t.Skip("age-keygen is required")
	}
	if _, err := exec.LookPath("fnox"); err != nil {
		t.Skip("fnox is required")
	}
	for _, explicit := range []bool{false, true} {
		name := "xdg"
		if explicit {
			name = "fnox-override"
		}
		t.Run(name, func(t *testing.T) {
			repo := repositoryRoot(t)
			root := t.TempDir()
			xdg := filepath.Join(root, "xdg")
			dir := filepath.Join(xdg, "fnox")
			env := map[string]string{"FNOX_CONFIG_DIR": "", "XDG_CONFIG_HOME": xdg}
			if explicit {
				dir = filepath.Join(root, "explicit")
				env["FNOX_CONFIG_DIR"] = dir
			}
			runCommand(t, repo, env, "bash", filepath.Join(repo, "setup", "init-fnox.sh"))
			configPath := filepath.Join(dir, "config.toml")
			assertRegularFile(t, configPath)
			assertRegularFile(t, filepath.Join(dir, "age.txt"))
			if output := runCommand(t, repo, env, "fnox", "config-files"); !strings.Contains(output, configPath) {
				t.Fatalf("fnox did not discover the generated configuration:\n%s", output)
			}
			if explicit {
				assertPathMissing(t, filepath.Join(xdg, "fnox"))
			}
		})
	}
}

// An existing identity is reused when creating the configuration.
func TestFnoxPreservesExistingKey(t *testing.T) {
	if _, err := exec.LookPath("age-keygen"); err != nil {
		t.Skip("age-keygen is required")
	}
	repo := repositoryRoot(t)
	dir := t.TempDir()
	env := map[string]string{"FNOX_CONFIG_DIR": dir}
	keyPath := filepath.Join(dir, "age.txt")
	runCommand(t, repo, env, "age-keygen", "-o", keyPath)
	before := runCommand(t, repo, env, "age-keygen", "-y", keyPath)
	runCommand(t, repo, env, "bash", filepath.Join(repo, "setup", "init-fnox.sh"))
	after := runCommand(t, repo, env, "age-keygen", "-y", keyPath)
	if before != after {
		t.Fatal("initialization replaced the existing identity")
	}
	assertRegularFile(t, filepath.Join(dir, "config.toml"))
}

// Initialization rejects links without changing their destinations.
func TestFnoxRejectsSymlinks(t *testing.T) {
	for _, target := range []string{"directory", "config.toml", "age.txt"} {
		t.Run(target, func(t *testing.T) {
			repo := repositoryRoot(t)
			root := t.TempDir()
			dir := filepath.Join(root, "config")
			foreign := filepath.Join(root, "foreign")
			if target == "directory" {
				if err := os.Mkdir(foreign, 0o700); err != nil {
					t.Fatal(err)
				}
				mustSymlink(t, foreign, dir)
			} else {
				mustWriteFile(t, foreign, "preserve me\n", 0o600)
				if err := os.Mkdir(dir, 0o700); err != nil {
					t.Fatal(err)
				}
				mustSymlink(t, foreign, filepath.Join(dir, target))
			}
			command := exec.Command("bash", filepath.Join(repo, "setup", "init-fnox.sh"))
			command.Env = replaceEnvironment(os.Environ(), map[string]string{"FNOX_CONFIG_DIR": dir})
			if err := command.Run(); err == nil {
				t.Fatal("initialization unexpectedly accepted a symlink")
			}
			if target == "directory" {
				assertLink(t, dir, foreign)
				assertPathMissing(t, filepath.Join(foreign, "age.txt"))
				assertPathMissing(t, filepath.Join(foreign, "config.toml"))
			} else {
				assertLink(t, filepath.Join(dir, target), foreign)
				assertFileContent(t, foreign, "preserve me\n")
			}
		})
	}
}
