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
# Source local files
# ===========================

# Function to resolve the absolute path of the dotfiles directory
get_dotfiles_dir() {
  # Get the actual path of the ~/.zshrc symlink
  local zshrc_symlink
  zshrc_symlink="$(readlink "${HOME}/.zshrc")"

  # Change to HOME to handle relative paths
  cd "${HOME}" || return 1

  # Get the absolute path to the dotfiles directory
  cd "$(dirname "$zshrc_symlink")" && pwd
}

# Function to execute the source script
run_source_script() {
  local current_dir
  current_dir="$(pwd)"  # Store the current working directory

  # Get the dotfiles directory
  local dotfiles_dir
  dotfiles_dir="$(get_dotfiles_dir)" || return 1

  # Execute the script from the scripts directory
  eval "$(bash "$dotfiles_dir/../scripts/source.sh")"

  # Return to the original working directory
  cd "$current_dir"
}

run_source_script


# ===========================
# History
# ===========================

# 履歴ファイルの保存先
export HISTFILE="$HOME/.zsh_history"

# メモリに保存される履歴の件数
export HISTSIZE=1000

# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000

setopt EXTENDED_HISTORY         # 開始と終了を記録する
setopt hist_ignore_all_dups     # 履歴が重複した場合に古い履歴を削除する
setopt hist_ignore_dups         # 古いコマンドの場合は履歴に追加しない
setopt hist_no_store            # historyコマンドは履歴に登録しない
setopt hist_reduce_blanks       # 余分な空白は詰めて記録する
setopt hist_save_no_dups        # 履歴ファイルに書き出す際、新しいコマンドと重複する古いコマンドは切り捨てる
setopt inc_append_history       # コマンド実行後すぐ履歴ファイルに追加
setopt inc_append_history_time  # 実行時間も含めて追加
setopt share_history            # 全てのセッションで履歴を共有する


# ===========================
# Options
# ===========================

setopt auto_cd            # ディレクトリ名でcdする
setopt correct            # コマンドのスペルミスを指摘
setopt ignoreeof          # Ctrl+d でシェルを終了しない
setopt magic_equal_subst  # コマンドラインの引数でも補完を有効にする（--prefix=/userなど）
setopt no_beep            # ビープ音を鳴らさない

# cd後に自動でlsする
function chpwd() {
  eza --color=always --group-directories-first --icons
}

# カレントディレクトリをターミナルのタブに表示
precmd() {
  print -Pn "\e]0;%~\a"
}

# venv: プロンプトに環境名を表示しない
export VIRTUAL_ENV_DISABLE_PROMPT=1

# brew installしたコマンドを即座に認識
zstyle ":completion:*:commands" rehash 1


# ===========================
# Paths
# ===========================

# Bun
export PATH="$HOME/.bun/bin:$PATH"

# Rancher Desktop
export PATH="$HOME/.rd/bin:$PATH"

# Go
export GOPATH=$HOME
export PATH="$PATH:$GOPATH/bin"

# AndroidStudio
# Official SDK root for Android Studio & sdkmanager/avdmanager
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
# Legacy SDK root for backward-compatibility (older scripts/CI)
export ANDROID_HOME="$ANDROID_SDK_ROOT"
# Include adb/fastboot
export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools"

# Dart CLI tools
export PATH="$PATH:$HOME/.pub-cache/bin"

# Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"


# ===========================
# Fzf
# ===========================

fzp () {
  local file
  file=$(fzf) && nvim "$file"
}

fzl () {
  local file_and_line
  file_and_line=$(rg --no-heading --line-number --color=always '' | fzf --ansi --delimiter=: --preview 'bat --color=always {1} --highlight-line {2}' --bind 'enter:execute(nvim {1} +{2})')
}


# ===========================
# Yazi
# ===========================

# Open Yazi and change directory to the one selected on exit
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


# ===========================
# Utilities
# ===========================

# Create a directory (if not exists) and move into it
mkcd() {
  mkdir -p "$1" && cd "$1" || return 1
}

# Move up N levels in the directory tree (default: 1)
# Usage example: up 3 # moves ../../..
up() {
  local count=${1:-1}
  cd "$(printf '../%.0s' $(seq 1 $count))" || return 1
}

# Search Google for the given query using the default browser
# Usage example: google how to configure Ghostty
function google() {
  local search_query="$@"
  local encoded_query=$(echo "$search_query" | sed 's/ /+/g')
  open "https://www.google.com/search?q=$encoded_query"
}


# ===========================
# Comments
# ===========================

echo "󰄳 Sourced: .zshrc"
