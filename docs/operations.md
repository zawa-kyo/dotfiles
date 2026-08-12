# 運用と確認

## 目的

変更対象に応じて、過不足の少ない確認を選べるようにする。

## 基本方針

- 小さな変更では最小限の確認をする
- 影響範囲が広い変更ではフォーマッタとリポジトリ全体の確認を使う
- ドキュメントだけの変更では重い確認は不要

## 変更種別ごとの確認

### ドキュメントのみ

- Markdown、TOML、JSON、JSONC を変更した場合は `mise run format`

### Neovim 設定

- Lua やフォーマッタの対象ファイルを変更した場合は `mise run format`
- プラグインやエディタ挙動に関わる場合は `nvim` で `:checkhealth`

### シェルスクリプト / タスク / 端末設定

- shell、TOML、Markdown を変更した場合は `mise run format`
- Bash または sh のスクリプトを変更した場合は `mise run check-shell`
- 配備処理やグローバルコマンドの公開に関わる場合は `mise run test-deployment`
- 実際のホームディレクトリへの配備状況は `mise run check-deployment` で確認する
- 影響範囲が広い場合は `uv run pre-commit run -a`

### Bun

- `mise run install-bun`
- `bunx --version`
- `packages/bun/node_modules/` が生成されていないことを確認する

旧構成では、`~/.bun/install/global` が `config/tools/bun/` へのシンボリックリンクになっている場合がある。
この場合、`mise run install-bun` はリンクを実行用ディレクトリへ置き換える。
既存の `node_modules/` は新しいディレクトリへ移動する。
別の場所を指すリンクや通常ファイルは変更しない。

移行後に問題が起きた場合は、まず Bun を使う処理を停止する。
その後、`node_modules/` を `packages/bun/` へ戻し、`~/.bun/install/global` をそのディレクトリへのリンクにできる。
この手順は切り戻しに限って使用する。

### Homebrew

- `brew bundle check --file=packages/homebrew/Brewfile`

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

実際のホームディレクトリは、変更を加えずに次のコマンドで確認できる。

```sh
mise run check-deployment
mise run diff-deployment
```

`check-deployment` は不一致があれば失敗し、`diff-deployment` は必要な操作を `link`、`relink`、`conflict` として表示する。
変更を適用する場合は `mise run relink` を使う。
配備先が通常ファイル、実ディレクトリ、または管理対象外を指すリンクである場合、この処理は配備先を変更せずに失敗する。

配備処理の変更に問題があった場合は、変更前のコミットへ戻して `mise run relink` を再実行する。
配備元のパスだけを変更した段階では、古いリンクもリポジトリ内を指す管理対象として判定されるため、変更前の一覧から再配備できる。

## ドキュメント更新の判断

- 手順が変わる
  - `README.md`
- リポジトリ全体の原則が変わる
  - `docs/`
- サブシステム固有の詳細規約が変わる
  - そのディレクトリ直下のポリシー
- エージェントの参照導線が変わる
  - `AGENTS.md`
