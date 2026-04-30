#!/usr/bin/env bash
# MISE_DESCRIPTION: Search Google with the default browser

set -euo pipefail

main() {
  local search_query
  local encoded_query

  search_query="$*"
  encoded_query="$(echo "$search_query" | sed 's/ /+/g')"
  exec open "https://www.google.com/search?q=$encoded_query"
}

main "$@"
