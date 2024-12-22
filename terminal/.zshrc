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
    sh "$dotfiles_dir/../scripts/source.sh"

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


setopt hist_ignore_dups     # 古いコマンドの場合は履歴に追加しない
setopt hist_save_no_dups    # 履歴ファイルに書き出す際、新しいコマンドと重複する古いコマンドは切り捨てる
setopt EXTENDED_HISTORY     # 開始と終了を記録する
setopt share_history        # 全てのセッションで履歴を共有する
setopt hist_ignore_all_dups # 履歴が重複した場合に古い履歴を削除する
setopt hist_reduce_blanks   # 余分な空白は詰めて記録する
setopt hist_no_store        # historyコマンドは履歴に登録しない
setopt inc_append_history  # コマンド実行後すぐ履歴ファイルに追加
setopt inc_append_history_time  # 実行時間も含めて追加


# ===========================
# Options
# ===========================

set -o ignoreeof          # Ctrl+d でシェルを終了しない
setopt magic_equal_subst  # コマンドラインの引数でも補完を有効にする（--prefix=/userなど）
setopt correct            # コマンドのスペルミスを指摘
setopt auto_cd            # ディレクトリ名でcdする

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
export PATH=$PATH:$GOPATH/bin

# AndroidStudio
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"


# ===========================
# Fzf
# ===========================

fv () {
	local file
	file=$(fzf) && nvim "$file"
}

fg () {
    local file_and_line
    file_and_line=$(rg --no-heading --line-number --color=always '' | fzf --ansi --delimiter=: --preview 'bat --color=always {1} --highlight-line {2}' --bind 'enter:execute(nvim {1} +{2})')
}


# ===========================
# Comments
# ===========================

echo "✅ Sourced: .zshrc"
