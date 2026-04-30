#!/usr/bin/env bash

# Print an informational status message.
info() {
  echo "󰄳 $1"
}

# Print a warning message to stderr.
warn() {
  echo "󰅙 $1" >&2
}

# Abort the script with an error message.
fail() {
  warn "$1"
  exit 1
}
