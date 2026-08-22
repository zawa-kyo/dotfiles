package bootstrap_test

import (
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

// Sourcing the fzf helper leaves caller-owned variables unchanged.
func TestFzfHelperDoesNotPolluteCallerVariables(t *testing.T) {
	repo := repositoryRoot(t)
	command := exec.Command("bash", "-c", `
script_dir=caller
source "$HELPER"
printf '%s\n' "$script_dir"
`)
	command.Dir = repo
	command.Env = replaceEnvironment(os.Environ(), map[string]string{
		"HELPER": filepath.Join(repo, "libexec", "fzf.sh"),
	})

	output, err := command.CombinedOutput()

	if err != nil {
		t.Fatalf("source fzf helper: %v\n%s", err, output)
	}
	if string(output) != "caller\n" {
		t.Fatalf("fzf helper changed caller variable:\n%s", output)
	}
}

// Requirement helpers return failure even when the caller defines fail.
func TestRequirementFailureReturnsToCaller(t *testing.T) {
	repo := repositoryRoot(t)
	command := exec.Command("bash", "-c", `
fail() {
  printf 'unexpected fail call\n' >&2
  exit 99
}
source "$HELPER"
if require_command command-that-does-not-exist; then
  exit 1
fi
printf 'continued\n'
`)
	command.Dir = repo
	command.Env = replaceEnvironment(os.Environ(), map[string]string{
		"HELPER": filepath.Join(repo, "libexec", "require.sh"),
	})

	output, err := command.CombinedOutput()

	if err != nil {
		t.Fatalf("requirement helper exited the caller: %v\n%s", err, output)
	}
	if strings.Contains(string(output), "unexpected fail call") || !strings.Contains(string(output), "continued") {
		t.Fatalf("requirement helper did not return cleanly:\n%s", output)
	}
}
