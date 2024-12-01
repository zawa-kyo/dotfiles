# Check if the local configuration directory exists
if [ -d "$ZDOTDIR/local.d" ]; then
  echo "📂 Loading configuration files from: $ZDOTDIR/local.d"

  # Loop through all .zsh files in the local.d directory
  for conf_file in "$ZDOTDIR/local.d/"*.zsh; do
    # If no .zsh files are found, exit the loop
    [ -e "$conf_file" ] || {
      echo "🚧 No configuration files found in $ZDOTDIR/local.d"
      break
    }

    # Output the file being sourced
    echo "🔧 Sourcing: $conf_file"
    source "${conf_file}"

    # Confirm the file was sourced
    echo "✅ Successfully sourced: $conf_file"
  done
else
  # If the configuration directory does not exist
  echo "❌ Configuration directory not found: $ZDOTDIR/local.d"
fi
