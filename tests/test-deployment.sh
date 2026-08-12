#!/usr/bin/env bash

set -euo pipefail

test_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd "$test_dir/.." && pwd)"
fixtures_dir="$(mktemp -d)"

# Remove only the temporary fixtures created for this test run.
cleanup() {
  rm -rf "$fixtures_dir"
}

# Abort with a focused assertion message.
fail_test() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

# Assert that the path is a symlink to the expected source.
assert_link() {
  local path="$1"
  local expected="$2"

  [ -L "$path" ] || fail_test "$path is not a symlink"
  [ "$(readlink "$path")" = "$expected" ] || fail_test "$path points to an unexpected source"
}

# Record managed symlinks so repeated runs can be compared.
record_links() {
  local root="$1"
  local output="$2"

  find "$root" -type l -print |
    while IFS= read -r link; do
      printf '%s -> %s\n' "${link#"$root"}" "$(readlink "$link")"
    done |
    sort >"$output"
}

# Verify the dotfile linker is safe and idempotent in an isolated HOME.
test_dotfile_links() {
  local home_dir="$fixtures_dir/link-home"
  local first_links="$fixtures_dir/links-first.txt"
  local second_links="$fixtures_dir/links-second.txt"

  mkdir -p "$home_dir"

  HOME="$home_dir" bash "$repo_dir/scripts/local/link-dotfiles.sh" >/dev/null
  assert_link "$home_dir/.gitconfig" "$repo_dir/config/tools/git/.gitconfig"
  assert_link "$home_dir/.config/nvim" "$repo_dir/config/editors/nvim"

  record_links "$home_dir" "$first_links"
  HOME="$home_dir" bash "$repo_dir/scripts/local/link-dotfiles.sh" >/dev/null
  record_links "$home_dir" "$second_links"
  cmp -s "$first_links" "$second_links" || fail_test "repeated linking changed the managed links"
}

# Verify existing regular files remain untouched.
test_regular_file_conflict() {
  local home_dir="$fixtures_dir/conflict-home"

  mkdir -p "$home_dir"
  printf 'user-owned\n' >"$home_dir/.gitconfig"

  HOME="$home_dir" bash "$repo_dir/scripts/local/link-dotfiles.sh" >/dev/null

  [ ! -L "$home_dir/.gitconfig" ] || fail_test "an existing regular file was replaced"
  [ "$(sed -n '1p' "$home_dir/.gitconfig")" = "user-owned" ] || fail_test "an existing regular file was modified"
}

# Verify platform-specific link definitions stay isolated from common links.
test_platform_links() {
  local home_dir="$fixtures_dir/platform-home"

  mkdir -p "$home_dir"

  (
    HOME="$home_dir"
    source "$repo_dir/scripts/utils/dotfiles-links.sh"
    uname() { printf 'Linux\n'; }
    populate_dotfiles_links "$repo_dir"

    for link in "${file_links[@]}"; do
      case "$link" in
      *"Library/Application Support"* | *"Library/Preferences"*)
        fail_test "macOS-specific link included for Linux"
        ;;
      esac
    done
  )

  (
    local found_vscode=false

    HOME="$home_dir"
    source "$repo_dir/scripts/utils/dotfiles-links.sh"
    uname() { printf 'Darwin\n'; }
    populate_dotfiles_links "$repo_dir"

    for link in "${file_links[@]}"; do
      case "$link" in
      *"Library/Application Support/Code/User/settings.json") found_vscode=true ;;
      esac
    done

    [ "$found_vscode" = true ] || fail_test "macOS-specific links were not defined for Darwin"
  )
}

# Verify every link definition has a source and a unique target.
test_link_inventory() {
  local home_dir="$fixtures_dir/inventory-home"
  local targets="$fixtures_dir/link-targets.txt"
  local source
  local target

  mkdir -p "$home_dir"

  (
    HOME="$home_dir"
    source "$repo_dir/scripts/utils/dotfiles-links.sh"
    populate_dotfiles_links "$repo_dir"

    : >"$targets"
    for link in "${file_links[@]}"; do
      IFS=: read -r source target <<<"$link"
      [ -f "$source" ] || fail_test "missing file source: $source"
      [ -n "$target" ] || fail_test "missing file target for $source"
      printf '%s\n' "$target" >>"$targets"
    done
    for link in "${directory_links[@]}"; do
      IFS=: read -r source target <<<"$link"
      [ -d "$source" ] || fail_test "missing directory source: $source"
      [ -n "$target" ] || fail_test "missing directory target for $source"
      printf '%s\n' "$target" >>"$targets"
    done
  )

  [ "$(wc -l <"$targets" | tr -d ' ')" = "$(sort -u "$targets" | wc -l | tr -d ' ')" ] ||
    fail_test "duplicate link targets found"
}

# Verify command publication preserves unrelated entries and is idempotent.
test_global_command_inventory() {
  local local_bin_dir="$fixtures_dir/bin"
  local mise_tasks_dir="$fixtures_dir/mise-tasks"
  local unrelated_target="$fixtures_dir/unrelated"
  local first_links="$fixtures_dir/commands-first.txt"
  local second_links="$fixtures_dir/commands-second.txt"
  local command_path
  local command_name

  mkdir -p "$local_bin_dir" "$mise_tasks_dir"
  : >"$unrelated_target"
  ln -s "$unrelated_target" "$local_bin_dir/unrelated"

  DIR_LOCAL_BIN="$local_bin_dir" DIR_MISE_TASKS="$mise_tasks_dir" \
    bash "$repo_dir/scripts/local/sync-global-commands.sh" >/dev/null

  for command_path in "$repo_dir/scripts/global/"*.sh; do
    command_name="$(basename "${command_path%.sh}")"
    assert_link "$local_bin_dir/$command_name" "$command_path"
    [ -x "$command_path" ] || fail_test "$command_path is not executable"
    grep -q '^# MISE_DESCRIPTION: .' "$command_path" || fail_test "$command_path has no description"
    grep -Fqx '# Generated by scripts/local/sync-global-commands.sh. Do not edit.' \
      "$mise_tasks_dir/$command_name" || fail_test "missing mise wrapper for $command_name"
  done

  assert_link "$local_bin_dir/unrelated" "$unrelated_target"
  record_links "$local_bin_dir" "$first_links"
  DIR_LOCAL_BIN="$local_bin_dir" DIR_MISE_TASKS="$mise_tasks_dir" \
    bash "$repo_dir/scripts/local/sync-global-commands.sh" >/dev/null
  record_links "$local_bin_dir" "$second_links"
  cmp -s "$first_links" "$second_links" || fail_test "repeated command sync changed published links"
}

trap cleanup EXIT

test_dotfile_links
test_regular_file_conflict
test_platform_links
test_link_inventory
test_global_command_inventory

printf 'Deployment tests passed.\n'
