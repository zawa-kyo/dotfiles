package bootstrap_test

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

// The published branch command delegates to the internal Git implementation.
func TestSwitchBranchCommand(t *testing.T) {
	repo := repositoryRoot(t)
	gitRepo := t.TempDir()
	fakeBin := t.TempDir()

	runCommand(t, gitRepo, nil, "git", "init", "-q", "-b", "main")
	runCommand(t, gitRepo, nil, "git", "config", "user.name", "Test User")
	runCommand(t, gitRepo, nil, "git", "config", "user.email", "test@example.com")
	mustWriteFile(t, filepath.Join(gitRepo, "README.md"), "fixture\n", 0o644)
	runCommand(t, gitRepo, nil, "git", "add", "README.md")
	runCommand(t, gitRepo, nil, "git", "commit", "-q", "-m", "fixture")
	runCommand(t, gitRepo, nil, "git", "branch", "alpha")
	mustWriteFile(t, filepath.Join(fakeBin, "fzf"), "#!/bin/sh\nhead -n 1\n", 0o755)

	output := runCommand(t, gitRepo, map[string]string{
		"PATH": fakeBin + string(os.PathListSeparator) + os.Getenv("PATH"),
	}, filepath.Join(repo, "bin", "switch-branch"))
	if !strings.Contains(output, "switched branch: alpha") {
		t.Fatalf("switch-branch did not report the selected branch:\n%s", output)
	}
	branch := strings.TrimSpace(runCommand(t, gitRepo, nil, "git", "branch", "--show-current"))
	if branch != "alpha" {
		t.Fatalf("current branch is %q, want alpha", branch)
	}
}
