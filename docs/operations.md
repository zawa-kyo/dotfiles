# 運用と確認

## 目的

変更内容に合った確認方法をまとめます。

## 基本方針

- 小さな変更では対象に近い箇所だけを確認する
- セットアップや PATH に関わる変更では結合テストと `mise run check` を実行する
- 実際のホームディレクトリへ反映する前に、状態確認または dry-run を行う
- ドキュメントだけの変更では重いテストを求めない

## 変更種別ごとの確認

### ドキュメントのみ

- `mise run format`

### Neovim 設定

- Lua やフォーマッタ対象ファイルを変更した場合は `mise run format`
- プラグイン、provider、runtime 設定を変更した場合は `nvim` で `:checkhealth`

### シェルスクリプト、タスク、端末設定

- `mise run format`
- Bash または sh を変更した場合は `mise run check-shell`
- セットアップ、PATH、公開コマンド、配備宣言に関わる場合は `mise run test-deployment`
- 影響範囲が広い場合は `mise run check`

### Bun

- `mise run install-bun`
- `bunx --version`
- `setup/bun/node_modules/` が生成されていないことを確認する

### mise

- グローバル設定の `auto_update = true` で standalone 版を定期的に更新する
- standalone 版の更新には `mise self-update` を使う
- 削除前には `mise implode --dry-run` で対象を確認する

### Homebrew

- 不足している Brewfile 依存関係を導入する場合は `mise run install-brew`
- Homebrew の導入は `mise bootstrap` と `mise run install` に含めない
- `brew bundle check --file=setup/homebrew/Brewfile`

## 配備状態の確認

実際のホームディレクトリを変更せずに、現在の状態を確認できます。

```sh
mise bootstrap dotfiles status
mise bootstrap dotfiles status --missing
mise bootstrap dotfiles apply --dry-run
```

`status` は各配備先の状態を表示します。`status --missing` は不足や不一致がある場合に失敗します。`apply --dry-run` は、適用時に行われる変更と競合を確認するために使います。

確認後にリンクを反映します。

```sh
mise bootstrap dotfiles apply --yes
```

競合時の動作は、[mise bootstrap 設計](bootstrap-design.md#競合の扱い)を参照してください。競合を一括で上書きする `--force` は、通常運用では使いません。

## 配備処理のテスト

```sh
mise run test-deployment
```

このタスクは Go テストを実行します。一時的な `HOME` と関連する状態ディレクトリを使い、実際の mise による配備、競合、再実行時の動作、OS 別宣言、APM と Bun の移行を確認します。実際のホームディレクトリは変更しません。

配備や移行の Go コードを変更した場合は、データ競合と静的な問題も確認します。

```sh
mise exec -- go test -race ./tests
mise exec -- go vet ./...
```

## dotfiles の配備を解除する場合

解除される対象を dry-run で確認してから実行します。

```sh
mise bootstrap dotfiles unapply --dry-run
mise bootstrap dotfiles unapply --yes
```

`unapply` は、現在の `[dotfiles]` 宣言とファイルの状態から mise が管理中と判定できる対象だけを削除します。`symlink-each` の配備先にある管理外の項目は残ります。配備後に内容が変わった `copy` のファイルがある場合は、操作全体が中止されます。必要な変更を配備元へ保存するか、配備元と同じ内容に戻してから再実行します。変更済みのファイルも削除する `--force` は、通常の初期化には使いません。

この操作で解除されるのは dotfiles の配備だけです。bootstrap タスクで導入したツール、パッケージ、生成データ、Git hook は残ります。dotfiles を再配備する場合は `mise bootstrap dotfiles apply --yes`、セットアップ全体を再実行する場合は `mise bootstrap --yes` を使います。

`[dotfiles]` から項目を削除する場合は、宣言を消す前に対象を指定して解除します。

```sh
mise bootstrap dotfiles unapply --dry-run ~/.zshrc
mise bootstrap dotfiles unapply --yes ~/.zshrc
```

生成データを伴う移行では、単純な `unapply` だけで済ませません。データを退避し、このリポジトリが作成したファイルだけを変更する migration を用意します。

## フォーマットと全体確認

```sh
mise run format
mise run check
```

`mise run format` は Go、Lua、shell、JSON、JSONC、Markdown、YAML、TOML を整形します。`mise run check` は Lefthook から各フォーマッタ、`go vet`、ShellCheck、Gitleaks、Git の差分を検査します。Git pre-commit hook ではステージ済みファイル、手動実行では追跡対象ファイル全体を確認します。

## ドキュメント更新の判断

- セットアップや利用手順が変わる
  - `README.md` と `README-ja.md`
- リポジトリ全体の原則が変わる
  - `docs/`
- サブシステム固有の詳細規約が変わる
  - 実装に近いポリシーファイル
- エージェントの参照先が変わる
  - `AGENTS.md` と `AGENTS-ja.md`
