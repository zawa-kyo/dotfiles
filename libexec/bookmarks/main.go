package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
	"os/exec"
	"sort"
	"strings"
)

type bookmark struct {
	browser  string
	location string
	title    string
	url      string
}

// Run the parser as a command-line helper.
func main() {
	if err := run(os.Args[1:], os.Stdout); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

// Parse the requested browser source and emit stable TSV records.
func run(args []string, output io.Writer) error {
	if len(args) == 0 {
		return errors.New("usage: go run main.go chrome PROFILE PATH | safari PATH")
	}

	entries := make(map[string]struct{})
	switch args[0] {
	case "chrome":
		if len(args) != 3 {
			return errors.New("usage: go run main.go chrome PROFILE PATH")
		}
		data, err := readJSONFile(args[2])
		if err != nil {
			return err
		}
		collectChromeBookmarks(data, args[1], entries)
	case "safari":
		if len(args) != 2 {
			return errors.New("usage: go run main.go safari PATH")
		}
		data, err := readSafariPlist(args[1])
		if err != nil {
			return err
		}
		collectSafariBookmarks(data, entries)
	default:
		return fmt.Errorf("unsupported browser source: %s", args[0])
	}

	records := make([]string, 0, len(entries))
	for record := range entries {
		records = append(records, record)
	}
	sort.Strings(records)
	for _, record := range records {
		fmt.Fprintln(output, record)
	}
	return nil
}

// Decode one JSON file without imposing a browser-specific schema.
func readJSONFile(path string) (any, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, fmt.Errorf("open %s: %w", path, err)
	}
	defer file.Close()

	var data any
	if err := json.NewDecoder(file).Decode(&data); err != nil {
		return nil, fmt.Errorf("decode %s: %w", path, err)
	}
	return data, nil
}

// Convert a Safari plist with the macOS system utility and decode its JSON output.
func readSafariPlist(path string) (any, error) {
	command := exec.Command("plutil", "-convert", "json", "-o", "-", path)
	output, err := command.Output()
	if err != nil {
		var exitError *exec.ExitError
		if errors.As(err, &exitError) && len(exitError.Stderr) > 0 {
			return nil, fmt.Errorf("convert %s: %s", path, strings.TrimSpace(string(exitError.Stderr)))
		}
		return nil, fmt.Errorf("convert %s: %w", path, err)
	}

	var data any
	if err := json.Unmarshal(output, &data); err != nil {
		return nil, fmt.Errorf("decode converted plist %s: %w", path, err)
	}
	return data, nil
}

// Collect Chrome URL nodes from parsed Bookmarks data.
func collectChromeBookmarks(node any, profile string, entries map[string]struct{}) {
	switch value := node.(type) {
	case []any:
		for _, child := range value {
			collectChromeBookmarks(child, profile, entries)
		}
	case map[string]any:
		url, hasURL := value["url"].(string)
		if nodeType, _ := value["type"].(string); nodeType == "url" && hasURL && url != "" {
			title, _ := value["name"].(string)
			if title == "" {
				title = url
			}
			addBookmark(entries, bookmark{browser: "Chrome", location: profile, title: title, url: url})
			return
		}
		for _, child := range value {
			collectChromeBookmarks(child, profile, entries)
		}
	}
}

// Collect Safari leaf bookmarks from converted plist data.
func collectSafariBookmarks(node any, entries map[string]struct{}) {
	switch value := node.(type) {
	case []any:
		for _, child := range value {
			collectSafariBookmarks(child, entries)
		}
	case map[string]any:
		nodeType, _ := value["WebBookmarkType"].(string)
		url, hasURL := value["URLString"].(string)
		if nodeType == "WebBookmarkTypeLeaf" && hasURL && url != "" {
			title := safariTitle(value)
			if title == "" {
				title = url
			}
			addBookmark(entries, bookmark{browser: "Safari", location: "Bookmarks", title: title, url: url})
			return
		}
		for _, child := range value {
			collectSafariBookmarks(child, entries)
		}
	}
}

// Read Safari title fields in preference order.
func safariTitle(node map[string]any) string {
	if uri, ok := node["URIDictionary"].(map[string]any); ok {
		if title, ok := uri["title"].(string); ok && title != "" {
			return title
		}
	}
	title, _ := node["Title"].(string)
	return title
}

// Store one normalized bookmark while removing duplicate records.
func addBookmark(entries map[string]struct{}, entry bookmark) {
	entry.browser = normalizeField(entry.browser)
	entry.location = normalizeField(entry.location)
	entry.title = normalizeField(entry.title)
	entry.url = normalizeField(entry.url)
	record := strings.Join([]string{entry.browser, entry.location, entry.title, entry.url}, "\t")
	entries[record] = struct{}{}
}

// Keep each bookmark on one TSV line.
func normalizeField(value string) string {
	return strings.NewReplacer("\t", " ", "\r", " ", "\n", " ").Replace(value)
}
