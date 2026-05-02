# コマンドとタスクの設計

## 目的

このリポジトリでは、日常的に使うコマンドを実行方式ごとに整理し、責務を混ぜないことを目指します。

## 3つの実行経路

### 単独実行コマンド

- 正本は `scripts/global/`
- `~/.local/bin` に公開される
- `mise` に依存せず直接実行できる

例:

- `reveal-repository-with-neovim`
- `add-worktree`
- `add-worktree-remote`
- `delete-worktree`
- `search-task`

### `mise run`

- task の入口と一覧
- インストール、整形、チェック、アップグレードのようなリポジトリ運用の導線
- 単独実行コマンドへの薄いラッパーもここに出す

### shell function

- 現在の shell session を直接変更する必要があるものは shell function に残す
- 外部プロセス化すると意味が壊れるものを対象にする

例:

- `reveal-repository`
- `reveal-repository-with-zoxide`

## 設計原則

### 単独実行コマンドの原則

- 日常利用する CLI は単独実行コマンドを優先する
- 実装の正本は `scripts/global/` に置く
- `mise` のラッパーは薄く保つ

### `mise` の原則

- リポジトリのセットアップ、整形、検証、アップグレードの入口に使う
- task の一覧として使う
- 直接の最短操作をすべて `mise run` に寄せない

### shell function の原則

- カレントディレクトリ変更など、親 shell を変える必要がある操作だけを残す
- 単にツールを起動するだけのものは単独実行コマンドに寄せる

## ディレクトリ分割

- `scripts/local/`
  - setup, install, sync のようなリポジトリ内ローカル処理
- `scripts/global/`
  - 公開する単独実行コマンド
- `scripts/utils/`
  - 共通補助スクリプト
- `.cache/mise/tasks/`
  - 生成された `mise` ラッパー

## 公開フロー

通常の公開経路は次です。

1. `scripts/global/` にコマンドを置く
2. `scripts/local/sync-global-commands.sh` で `~/.local/bin` にリンクする
3. 同じ sync で `.cache/mise/tasks/` にラッパーを生成する
4. `mise` から task として実行できるようにする

## 変更時の判断基準

- 新しい CLI を追加する
  - まず単独実行コマンドで成立するかを考える
- `mise` task を追加する
  - リポジトリ運用や一覧性に価値があるかを見る
- shell function を追加する
  - 親 shell を変える必要があるかを確認する
