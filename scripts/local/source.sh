#!/usr/bin/env zsh

SOURCE_SCRIPT_PATH="${${(%):-%N}:A}"
SOURCE_SCRIPT_DIR="${SOURCE_SCRIPT_PATH:h}"
source "${SOURCE_SCRIPT_DIR}/../utils/log.sh"

source_local_files() {
  local config_dir="$1"
  local extension="$2"
  local found=false
  local file

  if [[ ! -d "$config_dir" ]]; then
    missing "$config_dir"
    return
  fi

  for file in "$config_dir"/*"$extension"(N); do
    found=true
    source "$file"
    sourced "$file"
  done

  if [[ "$found" == false ]]; then
    not_found "$config_dir" "$extension"
  fi
}

source_local_files "$HOME/local.d" ".zsh"
