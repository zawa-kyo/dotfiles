# Check if the local configuration directory exists
if [ -d "$ZDOTDIR/local.d" ]; then
  for conf_file in "$ZDOTDIR/local.d/"*.zsh; do
    # If no .zsh files are found, exit the loop
    [ -e "$conf_file" ] || {
      echo "🚧 No configuration files found in $ZDOTDIR/local.d"
      break
    }
    source "${conf_file}"

    # Confirm the file was sourced
    echo "✅ Successfully sourced: $conf_file"
  done
else
  # If the configuration directory does not exist
  echo "❌ Configuration directory not found: $ZDOTDIR/local.d"
fi
