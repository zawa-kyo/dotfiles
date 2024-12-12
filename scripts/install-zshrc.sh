if [ -f ~/.dotfiles/terminal/.zshrc ]; then
  if [ -e "$HOME/.zshrc" ]; then
    echo "❌ $HOME/.zshrc already exists! Skipping link!"
  else
    ln -s ~/.dotfiles/terminal/.zshrc "$HOME/.zshrc"
    echo "✅ .zshrc linked successfully."
  fi
else
  echo "❌ .zshrc not found in dotfiles!"
  exit 1
fi
