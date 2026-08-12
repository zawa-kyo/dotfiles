# 運用と確認

## 目的

変更対象に応じて、過不足の少ない確認を選べるようにする。

## 基本方針

- 小さな変更では最小限の確認を行う
- 影響範囲が広い変更ではフォーマッタとリポジトリ全体の確認を使う
- ドキュメントだけの変更では重い確認は不要

## 変更種別ごとの確認

### ドキュメントのみ

- 必要に応じて `mise run format`

### Neovim 設定

- 必要に応じて `mise run format`
- プラグインやエディタ挙動に関わる場合は `nvim` で `:checkhealth`

### シェルスクリプト / タスク / 端末設定

- 必要に応じて `mise run format`
- 配備処理やグローバルコマンドの公開に関わる場合は `mise run test-deployment`
- 影響範囲が広い場合は `uv run pre-commit run -a`

### Bun

- `mise run install-bun`
- `bunx --version`
- `config/tools/bun/node_modules/` が生成されていないことを確認する

旧構成の `~/.bun/install/global` が `config/tools/bun/` へのシンボリックリンクである場合、`mise run install-bun` は実行用ディレクトリへ置き換え、既存の `node_modules/` を移動する。別の場所を指すリンクや通常ファイルは変更しない。

移行後に問題が起きた場合は、Bun を使う処理を停止し、`node_modules/` を `config/tools/bun/` へ戻してから、`~/.bun/install/global` を従来のリンクへ戻せる。この手順は切り戻しに限って使用する。

### Homebrew

- `brew bundle check --file=config/tools/homebrew/Brewfile`

## フォーマッタ

通常は次を使う。

```sh
mise run format
```

このタスクは Lua, shell, JSON / JSONC / Markdown / YAML, TOML をまとめて整形する。

## リポジトリ全体の確認

広い変更やリリース前確認では次を使う。

```sh
uv run pre-commit run -a
```

## 配備処理の確認

リンク処理やグローバルコマンドの公開を変更した場合は、次を実行する。

```sh
mise run test-deployment
```

このタスクは一時的な `HOME` を作り、現在の配備元と配備先、繰り返し実行した場合の結果、通常ファイルとの競合、OS 固有のリンク、公開コマンドの基本要件を確認する。
実際のホームディレクトリは変更しない。

## ドキュメント更新の判断

- 手順が変わる
  - `README.md`
- リポジトリ全体の原則が変わる
  - `docs/`
- サブシステム固有の詳細規約が変わる
  - そのディレクトリ直下のポリシー
- エージェントの参照導線が変わる
  - `AGENTS.md`
