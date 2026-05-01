#!/usr/bin/env bash

resolve_script_dir() {
  local source_path="$1"

  while [ -L "$source_path" ]; do
    local source_dir
    local link_target

    source_dir="$(cd "$(dirname "$source_path")" && pwd)"
    link_target="$(readlink "$source_path")"

    case "$link_target" in
      /*) source_path="$link_target" ;;
      *) source_path="$source_dir/$link_target" ;;
    esac
  done

  cd "$(dirname "$source_path")" && pwd
}
