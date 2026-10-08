#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/../libexec/log.sh"

config_dir="${FNOX_CONFIG_DIR:-$HOME/.config/fnox}"
config_file="$config_dir/config.toml"
key_file="$config_dir/age.txt"

# Never replace existing identities or follow links when initializing secrets.
for path in "$config_dir" "$config_file" "$key_file"; do
  [ ! -L "$path" ] || fail "Refusing to initialize fnox through a symlink: $path"
done

if [ -e "$config_file" ]; then
  [ -f "$config_file" ] || fail "fnox config is not a regular file: $config_file"
  [ -f "$key_file" ] || fail "fnox config exists without age.txt; restore the original key or review the config: $config_file"
  info "Preserved existing fnox configuration and key."
  exit 0
fi

umask 077
mkdir -p "$config_dir"
chmod 700 "$config_dir"

if [ -e "$key_file" ]; then
  [ -f "$key_file" ] || fail "fnox key is not a regular file: $key_file"
else
  age-keygen -o "$key_file"
fi
chmod 600 "$key_file"
recipient="$(age-keygen -y "$key_file")"

# Noclobber also protects against a configuration created concurrently.
set -o noclobber
cat >"$config_file" <<EOF
env = "exec"

[providers.local]
type = "age"
recipients = ["$recipient"]
key_file = "./age.txt"
EOF

info "Initialized fnox with a machine-specific age key. Back up the key and config securely."
