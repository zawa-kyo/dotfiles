# zshの設定ファイル
# シェルスクリプトの実行時には読み込まれないことに注意

# Store the current working directory before script execution
current_dir="$(pwd)"

# Get the actual path of the ~/.zshrc symlink
ZSHRC_SYMLINK="$(readlink "${HOME}/.zshrc")"

# Change to HOME to handle relative paths
cd "${HOME}" || return

# Get the absolute path to the directory
DOTFILES_DIR="$(cd "$(dirname "$ZSHRC_SYMLINK")" && pwd)"

# Execute the script from the scripts directory
sh "$DOTFILES_DIR/../scripts/source-zshrc.sh"

# Return to the original working directory
cd "$current_dir"

# ===========================
# User configuration
# ===========================

# Homebrew
typeset -U path PATH
path=(
	/opt/homebrew/bin(N-/)
	/usr/local/bin(N-/)
	$path
)

if (( $+commands[sw_vers] )) && (( $+commands[arch] )); then
	[[ -x /usr/local/bin/brew ]] && alias brew="arch -arch x86_64 /usr/local/bin/brew"
	alias x64='exec arch -x86_64 /bin/zsh'
	alias a64='exec arch -arm64e /bin/zsh'
	switch-arch() {
		if  [[ "$(uname -m)" == arm64 ]]; then
			arch=x86_64
		elif [[ "$(uname -m)" == x86_64 ]]; then
			arch=arm64e
		fi
		exec arch -arch $arch /bin/zsh
	}
fi


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

# ===========================
# Others
# ===========================

# venv
# プロンプトに環境名を表示しない
export VIRTUAL_ENV_DISABLE_PROMPT=1

# iTerm2
test -e "${HOME}/.iterm2_shell_integration.zsh"

# G
export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin

# Alias
# lsコマンドで常にファイル種別を表示
alias ls='ls -F'

# eza
# Replaced "ls" command
alias ls='eza --color=always --group-directories-first --icons'

# One file per line, with icons.
alias lS='eza -1 --color=always --group-directories-first --icons'

# Long listing of all files with icons and octal permissions.
alias l='eza -long --icons --octal-permissions --group-directories-first'

# Show all files in a long list, grouped, with directories first.
alias la='eza --long --all --group --group-directories-first'

# Show only hidden files.
alias l.="eza -a | grep -E '^\.'"

# Tree view with directories first and icons.
# Note: Using "-L" after setting "--level" overrides the previous level value.
alias lt='eza --tree --level=2 --color=always --group-directories-first --icons'

# AndroidStudio
PATH=$PATH:$HOME/Library/Android/sdk/platform-tools

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Starthip
eval "$(starship init zsh)"

# Vim
alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
NVIM_CONFIG=$HOME/.config/nvim/init.vim
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

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

# zsh-completions, zsh-autosuggestions
if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
	source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
	autoload -Uz compinit && compinit
fi

# Option+→を上書き、Shift+Tabでサジェストを一単語だけ受け入れる
bindkey -s '^[[Z' '^[f'

# mise
eval "$(mise activate zsh)"

# Bun
export PATH="$HOME/.bun/bin:$PATH"

# Rancher Desktop
export PATH="$HOME/.rd/bin:$PATH"

# Comment
echo "✅ .zshrc was loaded"
