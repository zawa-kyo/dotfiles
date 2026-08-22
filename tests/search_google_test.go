package bootstrap_test

import (
	"path/filepath"
	"testing"
)

// Google search queries are encoded as one URL query value.
func TestSearchGoogleCommandEncodesQuery(t *testing.T) {
	repo := repositoryRoot(t)
	fakeBin := t.TempDir()
	mustWriteFile(t, filepath.Join(fakeBin, "open"), "#!/bin/sh\nprintf '%s\\n' \"$@\"\n", 0o755)
	expected := "https://www.google.com/search?q=%E6%97%A5%E6%9C%AC%E8%AA%9E%20%26%20%23%20100%25\n"

	output := runCommand(t, repo, map[string]string{
		"PATH": pathWithPrefix(fakeBin),
	}, filepath.Join(repo, "bin", "search-google"), "日本語", "&", "#", "100%")

	if output != expected {
		t.Fatalf("search-google output is %q, want %q", output, expected)
	}
}
