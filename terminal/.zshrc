# zshの設定ファイル
# シェルスクリプトの実行時には読み込まれないことに注意

# ===========================
# Homebrew
# ===========================

# (N-/): もしそのディレクトリが存在していれば PATH に追加し、存在しなければ無視するオプション
typeset -U path PATH
path=(
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  /usr/bin
  /usr/sbin
  /bin
  /sbin
  /usr/local/bin(N-/)
  /usr/local/sbin(N-/)
  /Library/Apple/usr/bin
)

# Sheldon
eval "$(sheldon source)"

# ===========================
# User configuration
# ===========================

# Store the current working directory before script execution
current_dir="$(pwd)"

# Get the actual path of the ~/.zshrc symlink
ZSHRC_SYMLINK="$(readlink "${HOME}/.zshrc")"

# Change to HOME to handle relative paths
cd "${HOME}" || return

# Get the absolute path to the directory
DOTFILES_DIR="$(cd "$(dirname "$ZSHRC_SYMLINK")" && pwd)"

# Execute the script from the scripts directory
sh "$DOTFILES_DIR/../scripts/source.sh"

# Return to the original working directory
cd "$current_dir"


# ===========================
# Options
# ===========================

# Ctrl+d でシェルを終了しない
set -o ignoreeof

# コマンドラインの引数でも補完を有効にする（--prefix=/userなど）
setopt magic_equal_subst

# コマンドのスペルミスを指摘
setopt correct

# 直前と同じコマンドの場合は履歴に追加しない
setopt hist_ignore_dups

# ディレクトリ名でcd
setopt auto_cd

# cd後に自動でlsする
function chpwd() { eza --color=always --group-directories-first --icons }


# ===========================
# Others
# ===========================

# venv
# プロンプトに環境名を表示しない
export VIRTUAL_ENV_DISABLE_PROMPT=1

# iTerm2
test -e "${HOME}/.iterm2_shell_integration.zsh"

# Go
export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin

# AndroidStudio
PATH=$PATH:$HOME/Library/Android/sdk/platform-tools

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

fv () {
	local file
	file=$(fzf) && nvim "$file"
}
fg () {
    local file_and_line
    file_and_line=$(rg --no-heading --line-number --color=always '' | fzf --ansi --delimiter=: --preview 'bat --color=always {1} --highlight-line {2}' --bind 'enter:execute(nvim {1} +{2})')
}

# 新規にインストールしたコマンドを即座に認識
zstyle ":completion:*:commands" rehash 1

# Bun
export PATH="$HOME/.bun/bin:$PATH"

# Rancher Desktop
export PATH="$HOME/.rd/bin:$PATH"

# Comment
echo "✅ Loaded: .zshrc"
