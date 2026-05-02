#!/usr/bin/env bash
# MISE_DESCRIPTION: Browse zsh abbreviations with fzf and print the selected abbreviation

set -euo pipefail

main() {
  local abbreviation_column_width
  local xdg_data_home
  local plugin_path
  local selected

  command -v fzf >/dev/null 2>&1 || {
    echo "search-abbreviation: fzf is required." >&2
    exit 1
  }
  command -v zsh >/dev/null 2>&1 || {
    echo "search-abbreviation: zsh is required." >&2
    exit 1
  }

  xdg_data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
  abbreviation_column_width=18
  plugin_path="$xdg_data_home/sheldon/repos/github.com/olets/zsh-abbr/zsh-abbr.plugin.zsh"

  [ -f "$plugin_path" ] || {
    echo "search-abbreviation: zsh-abbr plugin not found at $plugin_path" >&2
    exit 1
  }

  selected="$(
    ABBREVIATION_COLUMN_WIDTH="$abbreviation_column_width" \
      ZSH_ABBR_PLUGIN_PATH="$plugin_path" zsh -fc '
      source "$ZSH_ABBR_PLUGIN_PATH"

      abbr list | while IFS= read -r line; do
        case "$line" in
          *"Sourced: .zshenv"*) continue ;;
        esac

        abbreviation=${line%%=*}
        expansion=${line#*=}
        quoted_abbreviation=${(Q)abbreviation}
        quoted_expansion=${(Q)expansion}
        printf "%s\t%-${ABBREVIATION_COLUMN_WIDTH}s\t%s\n" \
          "$quoted_abbreviation" \
          "$quoted_abbreviation" \
          "$quoted_expansion"
      done
    ' | SHELL=/bin/bash fzf \
      --delimiter=$'\t' \
      --with-nth=2,3 \
      --header=$'ABBREVIATION\tEXPANSION' \
      --prompt='abbreviation> ' \
      --preview $'printf "abbreviation: %s\n\nexpansion:\n%s\n" {1} {3}' \
      --preview-window='right,60%,wrap'
  )" || exit 1

  [ -n "$selected" ] || exit 1

  printf '%s\n' "${selected%%$'\t'*}"
}

main "$@"
