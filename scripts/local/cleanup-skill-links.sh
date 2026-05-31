#!/usr/bin/env bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_dir="$(cd "$script_dir/../.." && pwd)"
source "$script_dir/../utils/dotfiles-links.sh"

# Remove legacy skill symlinks before APM deploys managed skills.
cleanup_skill_links "$dotfiles_dir"
