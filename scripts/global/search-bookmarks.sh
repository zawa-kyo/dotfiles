#!/usr/bin/env bash
# MISE_DESCRIPTION: Select a Safari or Chrome bookmark with fzf and open it

set -euo pipefail

bootstrap_utils_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../utils"
if [ ! -f "$bootstrap_utils_dir/script-path.sh" ] && [ -L "${BASH_SOURCE[0]}" ]; then
  bootstrap_utils_dir="$(cd "$(dirname "$(readlink "${BASH_SOURCE[0]}")")" && pwd)/../utils"
fi
source "$bootstrap_utils_dir/script-path.sh"

script_dir="$(resolve_script_dir "${BASH_SOURCE[0]}")"
source "$script_dir/../utils/log.sh"

require_python3() {
  command -v python3 >/dev/null 2>&1 || fail "python3 is required for search-bookmarks."
}

usage() {
  cat <<'EOF'
Usage: search-bookmarks [all|chrome|safari]
       search-bookmarks --dump [all|chrome|safari]
EOF
}

emit_chrome_bookmarks() {
  local root
  local path
  local profile

  root="${CHROME_BOOKMARKS_ROOT:-$HOME/Library/Application Support/Google/Chrome}"

  for path in "$root"/Default/Bookmarks "$root"/Profile\ */Bookmarks; do
    [ -f "$path" ] || continue
    profile="$(basename "$(dirname "$path")")"

    python3 - "$profile" "$path" <<'PY'
import json
import sys

profile = sys.argv[1]
path = sys.argv[2]

def walk(node, entries):
    if isinstance(node, dict):
        if node.get("type") == "url":
            url = str(node.get("url", ""))
            if url:
                title = str(node.get("name", "")) or url
                entries.add((title, url))
        else:
            for child in node.values():
                walk(child, entries)
    elif isinstance(node, list):
        for child in node:
            walk(child, entries)

with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

entries = set()
walk(data, entries)

for title, url in sorted(entries, key=lambda item: (item[0].lower(), item[1])):
    print("\t".join(("Chrome", profile, title, url)))
PY
  done
}

emit_safari_bookmarks() {
  local plist

  plist="${SAFARI_BOOKMARKS_PLIST:-$HOME/Library/Safari/Bookmarks.plist}"
  [ -f "$plist" ] || return 0

  if ! python3 - "$plist" <<'PY'; then
import plistlib
import sys

path = sys.argv[1]

def title_for(node):
    uri = node.get("URIDictionary")
    if isinstance(uri, dict) and uri.get("title"):
        return str(uri["title"])

    title = node.get("Title")
    if title:
        return str(title)

    return ""

def walk(node, entries):
    if isinstance(node, dict):
        node_type = node.get("WebBookmarkType")
        if node_type == "WebBookmarkTypeLeaf":
            url = str(node.get("URLString", ""))
            if url:
                title = title_for(node) or url
                entries.add((title, url))
        else:
            for child in node.values():
                walk(child, entries)
    elif isinstance(node, list):
        for child in node:
            walk(child, entries)

with open(path, "rb") as f:
    data = plistlib.load(f)

entries = set()
walk(data, entries)

for title, url in sorted(entries, key=lambda item: (item[0].lower(), item[1])):
    print("\t".join(("Safari", "Bookmarks", title, url)))
PY
    warn "Safari bookmarks could not be read."
    warn "Check Safari bookmark file access and format."
    return 0
  fi
}

emit_bookmarks() {
  case "$1" in
  all)
    emit_chrome_bookmarks
    emit_safari_bookmarks
    ;;
  chrome)
    emit_chrome_bookmarks
    ;;
  safari)
    emit_safari_bookmarks
    ;;
  *)
    fail "Unsupported browser target: $1"
    ;;
  esac
}

open_selected_bookmark() {
  local browser="$1"
  local url="$2"

  case "$browser" in
  Chrome)
    exec open -a "Google Chrome" "$url"
    ;;
  Safari)
    exec open -a Safari "$url"
    ;;
  *)
    fail "Unsupported browser application: $browser"
    ;;
  esac
}

main() {
  local dump_mode=false
  local target="all"
  local bookmarks
  local selected
  local browser
  local location
  local title
  local url

  require_python3

  while [ "$#" -gt 0 ]; do
    case "$1" in
    --dump)
      dump_mode=true
      ;;
    all | chrome | safari)
      target="$1"
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 1
      ;;
    esac
    shift
  done

  bookmarks="$(
    emit_bookmarks "$target" |
      LC_ALL=C sort -t "$(printf '\t')" -k1,1 -k2,2 -k3,3f
  )"

  [ -n "$bookmarks" ] || fail "No bookmarks found for target: $target"

  if [ "$dump_mode" = true ]; then
    printf '%s\n' "$bookmarks"
    exit 0
  fi

  selected="$(
    printf '%s\n' "$bookmarks" |
      SHELL=/bin/sh fzf \
        --prompt='bookmarks> ' \
        --delimiter="$(printf '\t')" \
        --with-nth=1,2,3,4 \
        --preview-window='right,60%,wrap' \
        --preview '
          /bin/sh -c '"'"'
            browser="$1"
            location="$2"
            title="$3"
            url="$4"
            host="${url#*://}"
            host="${host%%/*}"

            printf "Browser  : %s\n" "$browser"
            printf "Location : %s\n" "$location"
            printf "Title    : %s\n" "$title"
            printf "Host     : %s\n" "${host:-N/A}"
            printf "URL      : %s\n" "$url"
          '"'"' sh {1} {2} {3} {4}
        '
  )" || exit 1

  [ -n "$selected" ] || exit 1

  IFS="$(printf '\t')" read -r browser location title url <<EOF
$selected
EOF

  [ -n "$url" ] || fail "Selected bookmark is missing a URL"
  open_selected_bookmark "$browser" "$url"
}

main "$@"
