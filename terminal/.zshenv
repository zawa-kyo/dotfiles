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

# Editor
export EDITOR="/opt/homebrew/bin/nvim"
export VISUAL="$EDITOR"

# ===========================
# Comments
# ===========================

echo "✅ Sourced: .zshenv"
