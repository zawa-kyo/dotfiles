# エージェント向けガイド

## このファイルの役割

- `AGENTS-ja.md` は `AGENTS.md` の日本語版。
- 詳細手順や長い背景説明はここに複製せず、参照先への導線だけを置く。
- 人向けの利用案内は `README-ja.md`、設計や運用の文書は `docs/README.md` を起点に参照する。

## 参照先一覧

- `README.md`
  - 人向けの英語版の入口。
  - セットアップ、日常運用、主要コマンド、全体構成の概要。
- `README-ja.md`
  - `README.md` の日本語版。
- `docs/README.md`
  - 設計文書の目次。
  - 目次から、リポジトリ全体または各ツールの文書をたどる。

## 変更対象ごとの参照先

- `dotfiles/editors/nvim/` を変更する場合:
  - `docs/README.md` を起点に、Neovim ドキュメントへの導線をたどる。
- `bin/`、`setup/`、`libexec/`、`mise.toml`、または `dotfiles/shell/` を変更する場合:
  - `docs/README.md` を起点に、コマンドモデルと省略入力の文書をたどる。
  - `fzf` を使う処理は、コマンドモデル記載の共通化方針に従う。
- `setup/homebrew/` を変更する場合:
  - `README.md` の Homebrew 節を読み、`docs/README.md` から確認方針の文書をたどる。
- `setup/bun/` を変更する場合:
  - `README.md` の Bun 節を読み、`docs/README.md` から確認方針の文書をたどる。
- `dotfiles/ai/` を変更する場合:
  - `README.md` の AI Tools 節を読み、`docs/README.md` から全体構成と AI ツールの文書をたどる。
- セットアップや利用手順の文書を変える場合:
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
- シェルスクリプトは既存スタイルに合わせ、実用上無理のない範囲で POSIX 寄りにする。
- 文字列検索には `rg` を使う。コードの構造に基づいて検索または置換する場合は `ast-grep` を使う。
- 新しい関数を追加する場合は、役割がひと目で分かる短い英語の説明コメントを付ける。
- JSON / JSONC / TOML / Markdown は既存フォーマットに合わせる。
- マシン固有の値や秘密情報はコミットしない。
- AI スキル本体は、原則として外部の apm パッケージリポジトリで管理する。このリポジトリには `dotfiles/ai/apm/apm.yml` の依存関係と `dotfiles/ai/apm/apm.lock.yaml` だけを置く。
- 対話型 CLI の利用を提案する場合は、まず `tmux` 経由で起動する案を勧める。

## 検証ルール

- ドキュメントのみの変更:
  - 必須テストはなし。
  - Markdown, TOML, JSON, JSONC を変更したら `mise run format` を実行する。
- `dotfiles/editors/nvim/` を変更した場合:
  - Lua またはフォーマッタ対象ファイルを変更したら `mise run format` を実行する。
  - プラグイン、provider、runtime 設定を変更したら `nvim` で `:checkhealth` を実行する。
- `bin/`、`setup/`、`libexec/`、`mise.toml`、または `dotfiles/shell/` を変更した場合:
  - シェル、TOML、Markdown ファイルを変更したら `mise run format` を実行する。
  - Bash または sh のスクリプトを変更したら `mise run check-shell` を実行する。
  - セットアップ、シェル起動、PATH、公開コマンドに影響する変更では `mise run check` を実行する。
- `setup/homebrew/Brewfile` を変更した場合:
  - `brew bundle check --file=setup/homebrew/Brewfile` を実行する。
- `setup/bun/` を変更した場合:
  - `mise run install-bun` を実行する。
- `bunx --version` で解決を確認する。

## ドキュメント更新ルール

- 新しいセットアップ手順を追加したら `README.md` と `README-ja.md` を更新する。
- 新しい全体設計の原則を追加したら `docs/` を更新する。
- 新しい Neovim 規約を追加したら `dotfiles/editors/nvim/docs/` とその目次を更新する。
- エージェント向けの参照導線が変わったら `AGENTS.md` を更新する。

## 言語版

このリポジトリで文章を生成または編集するときは、同じ内容を扱う英語の Markdown ファイルと対応する日本語の `*-ja.md` ファイルがあるか確認します。片方がある場合は同じ変更で両方を更新し、内容がずれないようにします。

英語版の Markdown ファイルに対応する日本語版は、同じディレクトリにある `*-ja.md` ファイルとします。

両方の版は意味を揃えます。ただし、それぞれの言語で自然に読める文章にしてください。日本語版は、意図が同じなら英語版を機械的に一行ずつ翻訳する必要はありません。

特に次の組み合わせに適用します。

- `README.md` と `README-ja.md`
- `AGENTS.md` と `AGENTS-ja.md`

## 注意事項

- `README.md` と `AGENTS.md` は英語を基本とする。
- `README-ja.md`、`AGENTS-ja.md`、各 `docs/` ディレクトリの文書は日本語を基本とする。
- `AGENTS.md` は短い入口として保ち、肥大化させない。
