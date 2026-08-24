# 起動時に読み込まれる設定ファイル
# ログインシェル以外でも必ずはじめに読み込まれる
# 基本的なPATH設定や、どんな状況でも共通して必要な環境変数を記述する

# ===========================
# Environmental variables
# ===========================

# Locale
export LANG="ja_JP.UTF-8"

# Time zone
export TZ="Asia/Tokyo"

# シェルの起動方法にかかわらず、ユーザー単位のコマンドを PATH に追加する
typeset -U path PATH
path=("$HOME/.local/bin"(N-/) $path)

# Load shared log helpers here because .zshenv runs before the other zsh startup files.
DOTFILES_TERMINAL_DIR="${${(%):-%N}:P:h}"
DOTFILES_ROOT_DIR="${DOTFILES_TERMINAL_DIR:h:h:h}"
source "${DOTFILES_ROOT_DIR}/libexec/log.sh"

# ===========================
# Comments
# ===========================

sourced ".zshenv"
