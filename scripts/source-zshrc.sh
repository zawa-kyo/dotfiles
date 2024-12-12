source_files_in_dir() {
  local config_dir="$1"
  local extension="$2"

  if [ -d "$config_dir" ]; then
    for conf_file in "$config_dir/"*"$extension"; do
      # If no files with the given extension are found, print a message and break
      [ -e "$conf_file" ] || {
        echo "🚧 No configuration files with extension $extension found in $config_dir"
        break
      }
      source "${conf_file}"
      echo "✅ Successfully sourced: $conf_file"
    done
  else
    # If the configuration directory does not exist
    echo "❌ Configuration directory not found: $config_dir"
  fi
}

source_files_in_dir "$HOME/local.d" ".zsh"
