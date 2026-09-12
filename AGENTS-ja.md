# エージェント向けガイド

## 目的

- `AGENTS-ja.md` は、コーディングエージェントを適切なドキュメントへ案内するためのガイドである。
- 詳細な手順や長い背景説明はこのファイルに記述せず、参照先への導線のみを配置する。
- ユーザー向けの利用手順は `README.md` (日本語版は `README-ja.md`)、リポジトリ全体の設計判断は `docs/`、各サブシステム固有のルールは実装の近くに記述する。

## 参照先一覧

- `README.md`
  - ユーザー向けドキュメント (英語版)。
  - セットアップ手順、日常的な運用、主要コマンド、リポジトリ全体の概要を記載。
- `README-ja.md`
  - `README.md` の日本語版。
- `docs/README.md`
  - 設計ドキュメントの目次。
  - リポジトリ全体および各ツール固有の設計ドキュメントへ案内する。

## 変更対象ごとの参照先

- `dotfiles/editors/nvim/` を変更する場合:
  - `docs/README.md` を起点に、Neovim ドキュメントへの導線をたどる。
- `bin/`、`setup/`、`libexec/`、`mise.toml`、または `dotfiles/shell/` を変更する場合:
  - `docs/README.md` を起点に、コマンドモデルと省略入力のドキュメントをたどる。
  - `fzf` を利用する処理は、コマンドモデルに記載されている共通化方針に従う。
- `setup/homebrew/` を変更する場合:
  - `README.md` の Homebrew セクションを確認し、`docs/README.md` から運用・確認方針のドキュメントをたどる。
- `setup/bun/` を変更する場合:
  - `README.md` の Bun セクションを確認し、`docs/README.md` から運用・確認方針のドキュメントをたどる。
- `dotfiles/ai/` を変更する場合:
  - `README.md` の AI Tools セクションを確認し、`docs/README.md` から全体構成および AI ツールのドキュメントをたどる。
- セットアップや利用手順のドキュメントを変更する場合:
  - `README.md` と `README-ja.md` の双方を更新する。
- リポジトリ全体の設計判断を変更する場合:
  - `docs/` 配下の該当ドキュメントを更新する。

## 編集ルール

- `AGENTS.md` に `README.md` や `docs/` の内容を重複して記述しない。
- ユーザー向けの手順は `README.md` にまとめる。
- リポジトリ全体の設計原則は `docs/` にまとめる。
- サブシステム固有の規約は実装の近くに配置する。
- インデントは 2 スペースを基本とする。
- Lua コードは `.stylua.toml` の規約に従う。
- シェルスクリプトは既存のスタイルに合わせ、実用上無理のない範囲で POSIX 準拠を意識する。
- 文字列検索には `rg` を使用する。コード構造に基づく検索や置換には `ast-grep` を使用する。
- 新しい関数を追加する場合は、役割がひと目で把握できる簡潔な英語コメントを付与する。
- JSON、JSONC、TOML、Markdown は既存のフォーマット規則に合わせる。
- マシン固有の値や機密情報はコミットしない。
- AI スキル本体は、原則として外部の apm パッケージリポジトリで管理する。本リポジトリには `dotfiles/ai/apm/apm.yml` の依存関係定義と `dotfiles/ai/apm/apm.lock.yaml` のみを配置する。
- 対話型 CLI の利用を提案する場合は、まず `tmux` 経由での起動を推奨する。

## 検証ルール

- ドキュメントのみの変更:
  - テストの実行は不要。
  - Markdown、TOML、JSON、JSONC を変更した場合は `mise run format` を実行する。
- `dotfiles/editors/nvim/` を変更した場合:
  - Lua またはフォーマッタ対象ファイルを変更した場合は `mise run format` を実行する。
  - プラグイン、provider、runtime 設定を変更した場合は `nvim` 内で `:checkhealth` を実行する。
- `bin/`、`setup/`、`libexec/`、`mise.toml`、または `dotfiles/shell/` を変更した場合:
  - シェルスクリプト、TOML、Markdown ファイルを変更した場合は `mise run format` を実行する。
  - Bash または sh スクリプトを変更した場合は `mise run check-shell` を実行する。
  - セットアップ処理、シェル起動、PATH、公開コマンドに影響する変更では `mise run check` を実行する。
- `setup/homebrew/Brewfile` を変更した場合:
  - `brew bundle check --file=setup/homebrew/Brewfile` を実行する。
- `setup/bun/` を変更した場合:
  - `mise run install-bun` を実行する。
  - `bunx --version` で依存関係の解決を確認する。

## ドキュメント更新ルール

- 新しいセットアップ手順を追加した場合は `README.md` と `README-ja.md` を更新する。
- リポジトリ全体の設計原則を追加した場合は `docs/` を更新する。
- Neovim の新しい規約を追加した場合は `dotfiles/editors/nvim/docs/` とその目次を更新する。
- エージェント向けの参照導線に変更が生じた場合は `AGENTS.md` を更新する。

## 多言語ドキュメントの同期

本リポジトリでドキュメントを作成または編集する際は、英語の Markdown ファイルとそれに対応する日本語の `*-ja.md` ファイルが存在するか確認する。対応ファイルが存在する場合は同一の変更内で双方を更新し、内容の整合性を保つ。

英語版の Markdown ファイルに対応する日本語版は、同一ディレクトリ内の `*-ja.md` ファイルとする。

両言語版で意味内容は一致させるが、それぞれの言語として自然な表現を重視する。日本語版を作成する際は、意図が同一であれば英語版を機械的に逐語訳する必要はない。

特に次の組み合わせに適用する。

- `README.md` と `README-ja.md`
- `AGENTS.md` と `AGENTS-ja.md`

## 注意事項

- `README.md` と `AGENTS.md` は英語で記述する。
- `README-ja.md`、`AGENTS-ja.md`、および `docs/` 配下のドキュメントは原則として日本語で記述する。
- `AGENTS.md` は簡潔な入口として保ち、肥大化させない。
