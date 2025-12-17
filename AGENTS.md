# Repository Guidelines

## プロジェクト構成と配置

- `nvim/`: Neovim 設定 (Lua) とプラグイン定義。Stylua で整形。
- `vscode/`: エディタ設定とキーバインド (`*.jsonc`)。VS Code のユーザーフォルダへシンボリックリンク。
- `scripts/`: セットアップ用スクリプト (例: `install-bun.sh`, `install.sh`, `source.sh`)。
- `homebrew/`: Homebrew の再現可能なインストール用 `Brewfile`。
- `bun/`: リポジトリ管理の Bun グローバルパッケージ (`package.json`, `bun.lock`)。
- `sheldon/`: Zsh プラグインマネージャ設定 (`plugins.toml`) と略語定義。
- `wezterm/`, `terminal/`, `ghostty/`, `zellij/`, `starship.toml`: ターミナル/プロンプト関連設定。
- `src/samples/`: エディタ/LSP 確認用の小さなサンプル。

## ビルド・テスト・開発コマンド

- 開発ツール導入: `pip install poetry && poetry install`
- pre-commit 有効化: `poetry run pre-commit install`
- 全ファイルでフック実行: `poetry run pre-commit run -a`
- Homebrew 適用: `brew bundle --file=homebrew/Brewfile`
- Bun グローバル準備: `sh scripts/install-bun.sh` (リンク作成後に `bun install` を実行)
- VS Code 同期: `README.md` の `ln -s` 手順を参照。

## コーディング規約と命名

- インデント: 2 スペース (Lua は `.stylua.toml` で強制)。
- 使用言語: Neovim は Lua、スクリプトは Bash、エディタ設定は JSON/JSONC。
- 命名: ディレクトリは小文字、スクリプトはハイフン区切り (例: `install-bun.sh`)。
- フォーマット: Lua は Stylua、JSON/JSONC は整合性維持、シェルは可能な限り POSIX 準拠。

## テスト指針

- Lint/セキュリティ: `poetry run pre-commit run -a` (`detect-secrets`, `gitleaks`, YAML/JSON チェックを含む)。
- Neovim ヘルス: プラグイン変更後に `nvim` で `:checkhealth`。
- Bun 確認: `scripts/install-bun.sh` 実行後、`bunx --version` で解決を確認。
- Homebrew: `brew doctor` と `brew bundle check --file=homebrew/Brewfile`。

## コミットとプルリクエスト

- コミット規約: Conventional Commits (例: `feat: ...`, `fix: ...`, `refactor: ...`, `style: ...`)。
- 関連 Issue/タスクをリンクし、PR は小さく焦点を絞る。

## セキュリティと設定の注意

- 秘密情報はコミットしない。pre-commit に依存し、`poetry run pre-commit run -a` で再確認。
- マシン固有のファイルはリポジトリ外に置くかテンプレート化。
- `Brewfile` 更新時は `brew bundle dump --file=homebrew/Brewfile --force` で状態を反映。
