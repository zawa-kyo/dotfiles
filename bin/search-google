#!/usr/bin/env bash
# DESCRIPTION: Search Google with the default browser

set -euo pipefail

main() {
  local search_query
  local encoded_query

  search_query="$*"
  encoded_query="${search_query// /+}"
  exec open "https://www.google.com/search?q=$encoded_query"
}

main "$@"
