#!/usr/bin/env bash
# MISE_DESCRIPTION: Show CPU and memory heavy processes with procs
# shellcheck disable=SC2016

set -euo pipefail

main() {
  local mode="${1:-all}"
  local json

  json="$(run_procs_json)"

  case "$mode" in
  all)
    print_processes "cpu" "$json"
    printf '\n'
    print_processes "memory" "$json"
    ;;
  cpu | memory)
    print_processes "$mode" "$json"
    ;;
  *)
    echo "Usage: reveal-process [all|cpu|memory]" >&2
    exit 2
    ;;
  esac
}

print_processes() {
  local mode="$1"
  local json="$2"
  local count=10
  local cols
  local sort_key
  local title

  cols="$(tput cols 2>/dev/null || printf '80')"
  case "$mode" in
  cpu)
    sort_key="CPU"
    title="Top $count processes by CPU usage are:"
    ;;
  memory)
    sort_key="MEM"
    title="Top $count processes by memory usage are:"
    ;;
  esac

  printf '%s\n' "$title"

  printf '%s\n' "$json" |
    run_jq -r --arg sort_key "$sort_key" --argjson count "$count" '
      sort_by(.[$sort_key]) | reverse | .[:$count][] |
      [
        .PID,
        .State,
        (.MEM / 1000),
        (.CPU / 1000),
        (.VmRSS / 1073741824),
        ."CPU Time",
        .Command
      ] | @tsv
    ' |
    awk -F '\t' -v cols="$cols" '
      BEGIN {
        reset = "\033[0m"
        white = "\033[38;5;15m"
        sep = "\033[37m"
        yellow = "\033[38;5;11m"
        green = "\033[38;5;10m"
        blue = "\033[38;5;12m"
        cyan = "\033[38;5;14m"
        red = "\033[38;5;9m"
        magenta = "\033[38;5;13m"

        command_width = cols - 49
        if (command_width < 24) {
          command_width = 24
        }

        printf " %s%-5s%s %s│%s %s%-5s %5s %5s %7s %-8s%s %s│%s %s%s\n", white, "PID", reset, sep, reset, white, "State", "MEM%", "CPU%", "RSSGB", "CPU Time", reset, sep, reset, white, "Command"
        printf " %s%-5s%s %s│%s %s%-5s %5s %5s %7s %-8s%s %s│%s\n", white, "", reset, sep, reset, white, "", "", "", "[GiB]", "", reset, sep, reset
      }

      function pct_color(value) {
        if (value >= 75) return red
        if (value >= 50) return yellow
        if (value >= 25) return green
        return blue
      }

      function rss_color(value) {
        if (value >= 4) return red
        if (value >= 1) return yellow
        return green
      }

      function state_color(state) {
        if (state == "R") return green
        if (state == "S") return blue
        if (state == "T") return cyan
        if (state == "Z") return magenta
        return yellow
      }

      function format_time(seconds) {
        hours = int(seconds / 3600)
        minutes = int((seconds % 3600) / 60)
        secs = int(seconds % 60)
        return sprintf("%02d:%02d:%02d", hours, minutes, secs)
      }

      {
        command = $7
        if (length(command) > command_width) {
          command = substr(command, 1, command_width)
        }

        mem_color = pct_color($3)
        cpu_color = pct_color($4)
        state_style = state_color($2)
        rss_style = rss_color($5)

        printf " %s%-5s%s %s│%s %s%-5s%s %s%5.1f%s %s%5.1f%s %s%7.2f%s %s%-8s%s %s│%s %s%s\n", yellow, $1, reset, sep, reset, state_style, $2, reset, mem_color, $3, reset, cpu_color, $4, reset, rss_style, $5, reset, cyan, format_time($6), reset, sep, reset, white, command reset
      }
    '
}

run_procs_json() {
  if command -v procs >/dev/null 2>&1; then
    procs --json
    return 0
  fi

  mise x procs -- procs --json
}

run_jq() {
  if command -v jq >/dev/null 2>&1; then
    jq "$@"
    return 0
  fi

  mise x jq -- jq "$@"
}

main "$@"
