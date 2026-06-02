# エージェント向けガイド

## このファイルの役割

- `AGENTS-ja.md` は `AGENTS.md` の日本語版です。
- 詳細手順や長い背景説明はここに複製せず、参照先への導線だけを置きます。
- 人向けの利用案内は `README-ja.md`、リポジトリ全体の設計判断は `docs/`、サブシステム固有の詳細規約は各ディレクトリ直下のポリシーを参照します。

## 参照先一覧

- `README.md`
  - 人向けの英語版の入口。
  - セットアップ、日常運用、主要コマンド、全体構成の概要。
- `README-ja.md`
  - `README.md` の日本語版。
- `docs/index.md`
  - 設計文書の目次。
- `docs/architecture.md`
  - リポジトリ全体の構造と責務分担。
- `docs/command-model.md`
  - 単独実行コマンド / シェル関数 / `mise run` の役割分担。
- `docs/abbreviation-policy.md`
  - シェルの省略コマンド名の設計原則。
- `docs/ai-tools.md`
  - AI ツール管理の運用方針。
- `docs/operations.md`
  - 変更後の確認方針。
- `config/editors/nvim/lua/policies/keybinds-policy.md`
  - Neovim キーバインド設計。
- `config/editors/nvim/lua/policies/tab-buffer-policy.md`
  - Neovim のタブ / バッファ表示方針。

## 変更対象ごとの参照先

- `config/editors/nvim/` を変更する場合:
  - まず `config/editors/nvim/lua/policies/` を確認する。
  - キーバインド変更は `config/editors/nvim/lua/policies/keybinds-policy.md` を確認する。
  - タブ / バッファ表示変更は `config/editors/nvim/lua/policies/tab-buffer-policy.md` を確認する。
- `scripts/`, `mise.toml`, `config/shell/terminal/`, `config/shell/sheldon/abbreviations` を変更する場合:
  - `docs/command-model.md` と `docs/abbreviation-policy.md` を確認する。
  - `fzf` を使う処理は `docs/command-model.md` の共通化方針に従う。
- `config/tools/homebrew/` を変更する場合:
  - `README.md` の Homebrew 節と `docs/operations.md` を確認する。
- `config/tools/bun/` を変更する場合:
  - `README.md` の Bun 節と `docs/operations.md` を確認する。
- `config/ai/` を変更する場合:
  - `README.md` の AI Tools 節、`docs/architecture.md`、`docs/ai-tools.md` を確認する。
- セットアップや利用手順を変える場合:
  - `README.md` と `README-ja.md` を更新する。
- リポジトリ全体に関わる設計判断を変える場合:
  - `docs/` を更新する。

## 編集ルール

- `AGENTS.md` に `README.md` や `docs/` の内容を複製しない。
- 人向けの手順は `README.md` にまとめる。
- リポジトリ全体の原則は `docs/` にまとめる。
- サブシステム固有の規約は実装の近くに置く。
- インデントは 2 スペースを基本とする。
- Lua は `.stylua.toml` に従う。
- シェルスクリプトは既存スタイルに合わせ、可能な限り POSIX 寄りを維持する。
- 新しい関数を追加する場合は、役割がひと目で分かる短い英語の説明コメントを付ける。
- JSON / JSONC / TOML / Markdown は既存フォーマットに合わせる。
- マシン固有の値や秘密情報はコミットしない。
- AI スキル本体は原則として外部の apm パッケージリポジトリで管理し、dotfiles には `config/ai/apm/apm.yml` の依存関係と `config/ai/apm/apm.lock.yaml` を置く。

## 検証ルール

- ドキュメントのみの変更:
  - 必須テストはなし。
  - Markdown, TOML, JSON, JSONC を変更したら `mise run format` を実行する。
- `config/editors/nvim/` を変更した場合:
  - Lua またはフォーマッタ対象ファイルを変更したら `mise run format` を実行する。
  - プラグイン、provider、runtime 設定を変更したら `nvim` で `:checkhealth` を実行する。
- `scripts/`, `mise.toml`, `config/shell/terminal/`, `config/shell/sheldon/abbreviations` を変更した場合:
  - シェル、TOML、Markdown ファイルを変更したら `mise run format` を実行する。
  - セットアップ、シェル起動、PATH、公開コマンドに影響する変更では `uv run pre-commit run -a` を実行する。
- `config/tools/homebrew/Brewfile` を変更した場合:
  - `brew bundle check --file=config/tools/homebrew/Brewfile` を実行する。
- `config/tools/bun/` を変更した場合:
  - `mise run install-bun` を実行する。
  - その後 `bunx --version` で解決確認。

## ドキュメント更新ルール

- 新しいセットアップ手順を追加したら `README.md` と `README-ja.md` を更新する。
- 新しい全体設計の原則を追加したら `docs/` を更新する。
- 新しい Neovim 規約を追加したら `config/editors/nvim/lua/policies/` を更新する。
- エージェント向けの参照導線が変わったら `AGENTS.md` を更新する。

## 言語版

このリポジトリで文章を生成または編集するときは、同じ内容に対して英語の Markdown ファイルと対応する日本語の `*-ja.md` ファイルが存在するか確認します。片方が存在する場合は、同じ変更で両方を更新し、内容がずれないようにします。

英語版の Markdown ファイルに対応する日本語版は、同じディレクトリにある `*-ja.md` ファイルとします。

両方の版は意味を揃えます。ただし、それぞれの言語で自然に読める文章にしてください。日本語版は、意図が同じなら英語版を機械的に一行ずつ翻訳する必要はありません。

特に次の組み合わせに適用します。

- `README.md` と `README-ja.md`
- `AGENTS.md` と `AGENTS-ja.md`

## 注意事項

- `README.md` と `AGENTS.md` は英語を基本とする。
- `README-ja.md`, `AGENTS-ja.md`, `docs/`, ポリシーは日本語を基本とする。
- `AGENTS.md` は短い入口として保ち、肥大化させない。
