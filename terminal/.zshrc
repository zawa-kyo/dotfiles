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

# Mise
eval "$(mise activate zsh)"

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

source "$(get_dotfiles_dir)/../scripts/lib/log.sh"

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

# brew installしたコマンドを即座に認識
zstyle ":completion:*:commands" rehash 1


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

# Select a ghq-managed repository interactively with fzf.
ghq-select () {
  local query="$*"
  local preview_cmd
  local -a fzf_opts
  preview_cmd='
    git_status=$(git -C {} status --short 2>/dev/null)
    if [ -n "$git_status" ]; then
      printf "%s\n\n" "$git_status"
    fi
    eza --tree --level=2 --git-ignore --color=always --icons {}
  '

  fzf_opts=(--preview "$preview_cmd")
  if [[ -n "$query" ]]; then
    fzf_opts+=(--query "$query")
  fi

  ghq list --full-path | fzf "${fzf_opts[@]}"
}

# Find a ghq-managed repository from keywords.
# When a query is given, prefer a direct match via zoxide, then a unique fuzzy match,
# and finally fall back to interactive selection with the query prefilled.
ghq-find () {
  local repo
  local ghq_root
  local query="$*"
  local matches=""
  local -a matched_repos

  if [[ $# -eq 0 ]]; then
    ghq-select
    return
  fi

  ghq_root="$(ghq root)"
  repo="$(zoxide query --base-dir "$ghq_root" "$@" 2>/dev/null)"
  if [[ -n "$repo" ]]; then
    print -r -- "$repo"
    return 0
  fi

  matches="$(ghq list --full-path | fzf --filter="$query" || true)"
  if [[ -n "$matches" ]]; then
    matched_repos=("${(@f)matches}")
    if (( ${#matched_repos} == 1 )); then
      print -r -- "$matched_repos[1]"
      return 0
    fi
  fi

  ghq-select "$@"
}

# Reveal a repository by changing into it.
reveal-repository () {
  local repo
  repo=$(ghq-find "$@") || return
  cd "$repo"
}

# Reveal a repository in VS Code.
reveal-repository-with-code () {
  local repo
  repo=$(ghq-find "$@") || return
  code "$repo"
}

# Reveal a repository in Fork.
reveal-repository-with-fork () {
  local repo
  repo=$(ghq-find "$@") || return
  fork "$repo"
}

# Reveal a repository in lazygit.
reveal-repository-with-lazygit () {
  local repo
  repo=$(ghq-find "$@") || return
  lazygit -p "$repo"
}

# Reveal a repository in Neovim.
reveal-repository-with-neovim () {
  local repo
  repo=$(ghq-find "$@") || return
  nvim "$repo"
}

# Reveal a repository with zoxide.
reveal-repository-with-zoxide () {
  local repo
  repo=$(ghq-find "$@") || return
  z "$repo"
}

# Add or reuse a worktree for a local branch selected with fzf.
add-worktree () {
  local branch
  local existing_path
  local preview_cmd='git log --oneline --decorate --color=always -20 -- {}'
  local repo_base_path
  local repo_path
  local repo_root

  command -v git >/dev/null 2>&1 || {
    warn "git is required"
    return 1
  }

  command -v fzf >/dev/null 2>&1 || {
    warn "fzf is required"
    return 1
  }

  repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    warn "not inside a git repository"
    return 1
  }

  branch="$(
    git for-each-ref --format='%(refname:short)' refs/heads |
      fzf --preview "$preview_cmd"
  )" || return 1

  [[ -n "$branch" ]] || return 1

  existing_path="$(
    git worktree list --porcelain |
      awk -v branch="refs/heads/$branch" '
        $1 == "worktree" { path = $2 }
        $1 == "branch" && $2 == branch { print path; exit }
      '
  )"
  if [[ -n "$existing_path" ]]; then
    warn "worktree already exists: $existing_path"
    print -r -- "$existing_path"
    return 0
  fi

  repo_base_path="${repo_root%%+*}"
  repo_path="${repo_base_path}+${branch//\//_}"
  if [[ -d "$repo_path" ]]; then
    warn "directory already exists: $repo_path"
    print -r -- "$repo_path"
    return 0
  fi

  git worktree add -q -- "$repo_path" "$branch" || return 1
  info "created worktree: $repo_path"
  print -r -- "$repo_path"
}

# Delete a linked worktree selected with fzf.
delete-worktree () {
  local confirm
  local current_path
  local preview_cmd
  local target_path

  command -v git >/dev/null 2>&1 || {
    warn "git is required"
    return 1
  }

  command -v fzf >/dev/null 2>&1 || {
    warn "fzf is required"
    return 1
  }

  current_path="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    warn "not inside a git repository"
    return 1
  }

  preview_cmd='
    branch=$(git -C {} branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
      printf "branch: %s\n\n" "$branch"
    fi
    git -C {} status --short --branch 2>/dev/null
  '

  target_path="$(
    git worktree list --porcelain |
      awk -v current="$current_path" '
        $1 == "worktree" { path = $2; next }
        $1 == "branch" && path != current { print path }
      ' |
      fzf --preview "$preview_cmd"
  )" || return 1

  [[ -n "$target_path" ]] || return 1

  if [[ -n "$(git -C "$target_path" status --short 2>/dev/null)" ]]; then
    warn "worktree has uncommitted changes: $target_path"
    return 1
  fi

  printf "Remove worktree %s? [y/N]: " "$target_path"
  read -r confirm
  if [[ "$confirm" != [Yy] ]]; then
    info "canceled"
    return 1
  fi

  git worktree remove -- "$target_path" || return 1
  info "removed worktree: $target_path"
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

alias rm="echo ' Heads up: rm is dangerous. Use trash instead!'"


# ===========================
# Comments
# ===========================

echo "󰄳 Sourced: .zshrc"
