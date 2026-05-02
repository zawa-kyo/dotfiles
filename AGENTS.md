# エージェント向けガイド

## このファイルの役割

- `AGENTS.md` はエージェント向けの入口です
- 詳細手順や長い背景説明はここに複製せず、正本への導線だけを置きます
- 人向けの利用案内は `README.md`、リポジトリ全体の設計判断は `docs/`、サブシステム固有の詳細規約は各ディレクトリ直下の policy を参照します

## 参照先一覧

- `README.md`
  - 人向けの入口
  - セットアップ、日常運用、主要コマンド、全体構成の概要
- `docs/index.md`
  - 設計文書の目次
- `docs/architecture.md`
  - リポジトリ全体の構造と責務分担
- `docs/command-model.md`
  - 単独実行コマンド / shell function / `mise run` の役割分担
- `docs/abbreviation-policy.md`
  - shell の省略コマンド名の設計原則
- `docs/operations.md`
  - 変更後の確認方針
- `nvim/lua/policies/keybinds-policy.md`
  - Neovim キーバインド設計の正本
- `nvim/lua/policies/tab-buffer-policy.md`
  - Neovim のタブ / バッファ表示方針の正本

## 変更対象ごとの参照先

- `nvim/` を変更する場合
  - まず `nvim/lua/policies/` を確認する
  - キーバインド変更は `nvim/lua/policies/keybinds-policy.md`
  - タブ/バッファ表示変更は `nvim/lua/policies/tab-buffer-policy.md`
- `scripts/`, `mise.toml`, `terminal/`, `sheldon/abbreviations` を変更する場合
  - `docs/command-model.md` と `docs/abbreviation-policy.md` を確認する
- `homebrew/` を変更する場合
  - `README.md` の Homebrew 節と `docs/operations.md` を確認する
- `bun/` を変更する場合
  - `README.md` の Bun 節と `docs/operations.md` を確認する
- `ai/` を変更する場合
  - `README.md` の AI Tools 節と `docs/architecture.md` を確認する
- セットアップや利用手順を変える場合
  - `README.md` を更新する
- リポジトリ全体に関わる設計判断を変える場合
  - `docs/` を更新する

## 編集ルール

- `AGENTS.md` に `README.md` や `docs/` の内容を複製しない
- 人向けの手順は `README.md` を正本にする
- リポジトリ全体の原則は `docs/` を正本にする
- サブシステム固有の規約は実装の近くに置き、そのファイルを正本にする
- インデントは 2 スペースを基本とする
- Lua は `.stylua.toml` に従う
- shell script は既存スタイルに合わせ、可能な限り POSIX 寄りを維持する
- 新しい関数を追加する場合は、役割がひと目で分かる短い英語の doc comment を付ける
- JSON / JSONC / TOML / Markdown は既存フォーマットに合わせる
- マシン固有の値や秘密情報はコミットしない

## 検証ルール

- ドキュメントのみの変更
  - 必須テストはなし
  - 必要なら `mise run format`
- `nvim/` を変更した場合
  - 必要に応じて `mise run format`
  - 必要に応じて `nvim` で `:checkhealth`
- `scripts/`, `mise.toml`, `terminal/`, `sheldon/abbreviations` を変更した場合
  - 必要に応じて `mise run format`
  - 影響範囲が広い場合は `uv run pre-commit run -a`
- `homebrew/Brewfile` を変更した場合
  - 必要に応じて `brew bundle check --file=homebrew/Brewfile`
- `bun/` を変更した場合
  - 必要に応じて `mise run install-bun`
  - その後 `bunx --version` で解決確認

## ドキュメント更新ルール

- 新しいセットアップ手順を追加したら `README.md` を更新する
- 新しい全体設計の原則を追加したら `docs/` を更新する
- 新しい Neovim 規約を追加したら `nvim/lua/policies/` を更新する
- エージェント向けの参照導線が変わったら `AGENTS.md` を更新する

## 注意事項

- `README.md` は英語、`AGENTS.md` と `docs/` と policy 文書は日本語を基本とする
- `AGENTS.md` は短い入口として保ち、肥大化させない
