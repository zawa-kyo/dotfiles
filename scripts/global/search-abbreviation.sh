#!/usr/bin/env bash
# MISE_DESCRIPTION: Browse zsh abbreviations with fzf and print the selected abbreviation

set -euo pipefail

script_path="$(realpath "${BASH_SOURCE[0]}")"
script_dir="$(cd "$(dirname "$script_path")" && pwd)"
source "$script_dir/../utils/fzf.sh"

main() {
  local abbreviations_file
  local abbreviation_column_width
  local selected

  abbreviations_file="${XDG_CONFIG_HOME:-$HOME/.config}/zsh-abbr/user-abbreviations"
  abbreviation_column_width=18

  [ -f "$abbreviations_file" ] || {
    echo "search-abbreviation: abbreviations file not found at $abbreviations_file" >&2
    exit 1
  }

  selected="$(
    while IFS= read -r line; do
      if [[ $line =~ ^abbr\ \'([^\']+)\'=\'(.*)\'$ ]]; then
        abbreviation="${BASH_REMATCH[1]}"
        expansion="${BASH_REMATCH[2]}"
        printf "%s\t%-${abbreviation_column_width}s\t%s\n" \
          "$abbreviation" \
          "$abbreviation" \
          "$expansion"
      fi
    done <"$abbreviations_file" | run_fzf_with_preview $'printf "abbreviation: %s\n\nexpansion:\n%s\n" {1} {3}' \
      --delimiter=$'\t' \
      --with-nth=2,3 \
      --header=$'ABBREVIATION\tEXPANSION' \
      --prompt='abbreviation> ' \
      --preview-window='right,60%,wrap'
  )" || exit 1

  [ -n "$selected" ] || exit 1

  printf '%s\n' "${selected%%$'\t'*}"
}

main "$@"
