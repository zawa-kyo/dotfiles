#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_dir="$(cd "$script_dir/.." && pwd)"
venv_dir="$dotfiles_dir/.venv"

. "$script_dir/lib/log.sh"

hook_path="$(git -C "$dotfiles_dir" rev-parse --git-path hooks/pre-commit)"

# Recreate the local virtual environment from the tracked dev dependencies.
recreate_virtualenv() {
  if [ -d "$venv_dir" ]; then
    rm -rf "$venv_dir"
    info "Existing virtual environment removed."
  fi

  (
    cd "$dotfiles_dir"
    uv sync --group dev
  )
  info "Python development environment recreated successfully."
}

# Install a portable pre-commit hook that resolves the repo root at runtime.
write_hook() {
  mkdir -p "$(dirname "$hook_path")"

  cat >"$hook_path" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
hook_dir="$(cd "$(dirname "$0")" && pwd)"
python_bin="$repo_root/.venv/bin/python"

if [ ! -x "$python_bin" ]; then
  echo 'Repo virtualenv not found. Run `mise run install-pre-commit` first.' >&2
  exit 1
fi

cd "$repo_root"
exec "$python_bin" -m pre_commit hook-impl --config=.pre-commit-config.yaml --hook-type=pre-commit --hook-dir "$hook_dir" -- "$@"
EOF

  chmod 755 "$hook_path"
  info "Portable pre-commit hook installed successfully."
}

# Run the full pre-commit hook installation flow.
main() {
  recreate_virtualenv
  write_hook
}

main "$@"
