#!/usr/bin/env bash

# Prints content of matching files so zsh can 'eval' it later
emit_sources() {
  local config_dir="$1"
  local extension="$2"
  local found=false

  # Check if directory exists
  if [ ! -d "$config_dir" ]; then
    echo "echo '❌ Directory not found: $config_dir' 1>&2"
    return
  fi

  # Iterate through files with the given extension
  for file in "$config_dir/"*"$extension"; do
    [ -e "$file" ] || continue
    found=true

    # Output the file content directly (zsh-compatible syntax expected)
    cat "$file"

    # Emit an echo command for logging
    echo "echo '󰄳 Sourced: $file' 1>&2"
  done

  # If no file was found
  if [ "$found" = false ]; then
    echo "echo '󰒡 No *$extension files found in $config_dir' 1>&2"
  fi
}

emit_sources "$HOME/local.d" ".zsh"
