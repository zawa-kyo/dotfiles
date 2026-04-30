#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_dir="$(cd "$script_dir/.." && pwd)"

. "$script_dir/lib/log.sh"

hook_path="$(git -C "$dotfiles_dir" rev-parse --git-path hooks/pre-commit)"

# Ensure the Python development environment is available.
sync_dev_dependencies() {
  (
    cd "$dotfiles_dir"
    uv sync --group dev
  )
  info "Python development dependencies synced successfully."
}

# Install a portable pre-commit hook that resolves the repo root at runtime.
write_hook() {
  mkdir -p "$(dirname "$hook_path")"

  cat >"$hook_path" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if ! command -v uv >/dev/null 2>&1; then
  echo '`uv` not found. Install uv before running pre-commit hooks.' >&2
  exit 1
fi

repo_root="$(git rev-parse --show-toplevel)"
hook_dir="$(cd "$(dirname "$0")" && pwd)"

cd "$repo_root"
exec uv run pre-commit hook-impl --config=.pre-commit-config.yaml --hook-type=pre-commit --hook-dir "$hook_dir" -- "$@"
EOF

  chmod 755 "$hook_path"
  info "Portable pre-commit hook installed successfully."
}

# Run the full pre-commit hook installation flow.
main() {
  sync_dev_dependencies
  write_hook
}

main "$@"
