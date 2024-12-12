# Check if the local configuration directory exists
if [ -d "$HOME/local.d" ]; then
  for conf_file in "$HOME/local.d/"*.zsh; do
    # If no .zsh files are found, exit the loop
    [ -e "$conf_file" ] || {
      echo "🚧 No configuration files found in $HOME/local.d"
      break
    }
    source "${conf_file}"

    # Confirm the file was sourced
    echo "✅ Successfully sourced: $conf_file"
  done
else
  # If the configuration directory does not exist
  echo "❌ Configuration directory not found: $HOME/local.d"
fi
