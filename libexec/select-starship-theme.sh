#!/usr/bin/env bash

set -euo pipefail

script_path="$(realpath "${BASH_SOURCE[0]}")"
script_dir="$(cd "$(dirname "$script_path")" && pwd)"
source "$script_dir/fzf.sh"
source "$script_dir/require.sh"

main() {
  local themes_dir="${STARSHIP_THEMES_DIR:-$HOME/.config/starship/themes}"
  local default_theme="${STARSHIP_DEFAULT_THEME}"
  local selected

  require_file "$default_theme" "search-theme: default starship theme not found at $default_theme" || exit 1

  selected="$(
    find "$themes_dir" -maxdepth 1 -type f -name '*.toml' -print |
      sort |
      while IFS= read -r theme_path; do
        printf "%s\t%s\n" "$(basename "$theme_path" .toml)" "$theme_path"
      done |
      run_fzf_with_preview 'bat --style=numbers --color=always {2}' \
        --delimiter=$'\t' \
        --with-nth=1 \
        --header='STARSHIP THEME' \
        --prompt='starship theme> ' \
        --preview-window='right,60%,wrap'
  )" || exit 1

  [ -n "$selected" ] || exit 1
  printf '%s\n' "${selected#*$'\t'}"
}

main "$@"
