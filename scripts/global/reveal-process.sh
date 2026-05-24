#!/usr/bin/env bash
# MISE_DESCRIPTION: Show CPU and memory heavy processes with procs

set -euo pipefail

process_count=10
header_lines=2

main() {
  local mode="${1:-all}"

  case "$mode" in
  all)
    print_processes "cpu"
    printf '\n'
    print_processes "memory"
    ;;
  cpu | memory)
    print_processes "$mode"
    ;;
  *)
    echo "Usage: reveal-process [all|cpu|memory]" >&2
    exit 2
    ;;
  esac
}

# Print one ranking while leaving columns, colors, and width handling to procs.toml.
print_processes() {
  local mode="$1"
  local config_path
  local limit

  config_path="$(procs_config_path)"
  limit=$((process_count + header_lines))

  case "$mode" in
  cpu)
    echo "Top $process_count processes by CPU usage are:"
    with_sort_column "$config_path" 4 run_procs --pager disable | head -n "$limit"
    ;;
  memory)
    echo "Top $process_count processes by memory usage are:"
    run_procs --load-config "$config_path" --pager disable | head -n "$limit"
    ;;
  esac
}

procs_config_path() {
  local script_path
  local script_dir

  script_path="$(realpath "${BASH_SOURCE[0]}")"
  script_dir="$(cd "$(dirname "$script_path")" && pwd)"
  printf '%s\n' "$script_dir/../../procs/procs.toml"
}

with_sort_column() {
  local config_path="$1"
  local sort_column="$2"
  shift 2

  local tmpfile
  tmpfile="$(mktemp)"
  trap 'rm -f "$tmpfile"' RETURN

  awk -v sort_column="$sort_column" '
    /^\[sort\]$/ {
      in_sort = 1
      print
      next
    }

    /^\[/ {
      in_sort = 0
    }

    in_sort && /^column = / {
      print "column = " sort_column
      next
    }

    { print }
  ' "$config_path" >"$tmpfile"

  "$@" --load-config "$tmpfile"
}

run_procs() {
  if command -v procs >/dev/null 2>&1; then
    procs "$@"
    return 0
  fi

  mise -q x procs -- procs "$@"
}

main "$@"
