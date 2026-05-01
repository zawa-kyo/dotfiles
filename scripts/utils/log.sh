#!/usr/bin/env bash

# Print an informational status message.
info() {
  echo "󰄳 $1"
}

# Print a sourced-file status message to stderr.
sourced() {
  echo "󰄳 Sourced: $1" >&2
}

# Print a warning message to stderr.
warn() {
  echo "󰅙 $1" >&2
}

# Print a missing-directory status message to stderr.
missing() {
  echo "󰅙 Directory not found: $1" >&2
}

# Print a no-match status message to stderr.
not_found() {
  echo "󰒡 No *$2 files found in $1" >&2
}

# Abort the script with an error message.
fail() {
  warn "$1"
  exit 1
}
