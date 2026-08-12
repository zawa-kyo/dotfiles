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
  [ -d "$home_dir/.apm" ] && [ ! -L "$home_dir/.apm" ] || fail_test "APM user data directory is not a real directory"
  assert_link "$home_dir/.apm/apm.yml" "$repo_dir/config/ai/apm/apm.yml"
  assert_link "$home_dir/.apm/apm.lock.yaml" "$repo_dir/config/ai/apm/apm.lock.yaml"

  record_links "$home_dir" "$first_links"
  HOME="$home_dir" bash "$repo_dir/scripts/local/link-dotfiles.sh" >/dev/null
  record_links "$home_dir" "$second_links"
  cmp -s "$first_links" "$second_links" || fail_test "repeated linking changed the managed links"
}

# Verify the legacy whole-directory APM link migrates without replacing foreign links.
test_apm_directory_migration() {
  local home_dir="$fixtures_dir/apm-migration-home"
  local foreign_home_dir="$fixtures_dir/apm-foreign-home"
  local foreign_dir="$fixtures_dir/foreign-apm"
  local repo_copy="$fixtures_dir/apm-repo"

  mkdir -p "$home_dir" "$foreign_home_dir" "$foreign_dir" "$repo_copy/config/ai/apm"
  cp "$repo_dir/config/ai/apm/apm.yml" "$repo_copy/config/ai/apm/apm.yml"
  mkdir -p "$repo_copy/config/ai/apm/apm_modules/test-package"
  printf 'cached\n' >"$repo_copy/config/ai/apm/apm_modules/test-package/content"
  ln -s "$repo_copy/config/ai/apm" "$home_dir/.apm"

  (
    HOME="$home_dir"
    source "$repo_dir/scripts/utils/dotfiles-links.sh"
    migrate_apm_config_dir "$repo_copy"
  ) >/dev/null
  [ -d "$home_dir/.apm" ] && [ ! -L "$home_dir/.apm" ] || fail_test "legacy APM link was not migrated"
  [ -f "$home_dir/.apm/apm_modules/test-package/content" ] || fail_test "APM modules were not migrated"
  [ ! -e "$repo_copy/config/ai/apm/apm_modules" ] || fail_test "legacy APM modules remained in the repository"

  ln -s "$foreign_dir" "$foreign_home_dir/.apm"
  if HOME="$foreign_home_dir" bash "$repo_dir/scripts/local/link-dotfiles.sh" >/dev/null 2>&1; then
    fail_test "foreign APM link was replaced"
  fi
  assert_link "$foreign_home_dir/.apm" "$foreign_dir"
}

# Verify Bun declarations stay in the repo while generated modules move outside it.
test_bun_data_migration() {
  local source_dir="$fixtures_dir/bun-source"
  local global_dir="$fixtures_dir/bun-global"
  local global_bin_dir="$fixtures_dir/bun-bin"
  local fake_bin_dir="$fixtures_dir/fake-bin"
  local foreign_dir="$fixtures_dir/foreign-bun"

  mkdir -p "$source_dir/node_modules/.bin" "$fake_bin_dir" "$foreign_dir"
  printf '{"dependencies":{}}\n' >"$source_dir/package.json"
  printf 'lock-before\n' >"$source_dir/bun.lock"
  printf '[install]\n' >"$source_dir/bunfig.toml"
  printf '#!/usr/bin/env bash\n' >"$source_dir/node_modules/.bin/example"
  chmod +x "$source_dir/node_modules/.bin/example"
  ln -s "$source_dir" "$global_dir"

  cat >"$fake_bin_dir/bun" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

mode="$1"
shift
runtime_dir=""
while [ "$#" -gt 0 ]; do
  case "$1" in
  --cwd)
    runtime_dir="$2"
    shift 2
    ;;
  *) shift ;;
  esac
done

if [ "$mode" = update ]; then
  printf '{"updated":true}\n' >"$runtime_dir/package.json"
  printf 'lock-after\n' >"$runtime_dir/bun.lock"
fi
EOF
  chmod +x "$fake_bin_dir/bun"

  PATH="$fake_bin_dir:$PATH" DIR_BUN_SOURCE="$source_dir" DIR_BUN_GLOBAL="$global_dir" DIR_BUN_BIN="$global_bin_dir" \
    bash "$repo_dir/scripts/local/install-bun.sh" >/dev/null

  [ -d "$global_dir" ] && [ ! -L "$global_dir" ] || fail_test "Bun runtime directory is not a real directory"
  [ ! -e "$source_dir/node_modules" ] || fail_test "Bun modules remained in the repository source"
  [ -f "$global_dir/node_modules/.bin/example" ] || fail_test "Bun modules were not migrated"
  assert_link "$global_bin_dir/example" "$(realpath "$global_dir/node_modules/.bin/example")"

  PATH="$fake_bin_dir:$PATH" DIR_BUN_SOURCE="$source_dir" DIR_BUN_GLOBAL="$global_dir" DIR_BUN_BIN="$global_bin_dir" \
    bash "$repo_dir/scripts/local/install-bun.sh" upgrade >/dev/null
  grep -Fqx '{"updated":true}' "$source_dir/package.json" || fail_test "updated Bun manifest was not copied back"
  grep -Fqx 'lock-after' "$source_dir/bun.lock" || fail_test "updated Bun lock file was not copied back"

  rm -rf "$global_dir"
  ln -s "$foreign_dir" "$global_dir"
  if PATH="$fake_bin_dir:$PATH" DIR_BUN_SOURCE="$source_dir" DIR_BUN_GLOBAL="$global_dir" DIR_BUN_BIN="$global_bin_dir" \
    bash "$repo_dir/scripts/local/install-bun.sh" >/dev/null 2>&1; then
    fail_test "foreign Bun link was replaced"
  fi
  assert_link "$global_dir" "$foreign_dir"
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
test_apm_directory_migration
test_bun_data_migration
test_regular_file_conflict
test_platform_links
test_link_inventory
test_global_command_inventory

printf 'Deployment tests passed.\n'
