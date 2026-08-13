# 運用と確認

## 目的

変更対象に応じて、過不足の少ない確認を選べるようにします。

## 基本方針

- 小さな変更では対象に近い箇所だけを確認する
- セットアップや PATH に関わる変更では結合テストと pre-commit を実行する
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
- 影響範囲が広い場合は `uv run pre-commit run -a`

### Bun

- `mise run install-bun`
- `bunx --version`
- `config/tools/bun/node_modules/` が生成されていないことを確認する

旧構成では、`~/.bun/install/global` が旧リポジトリ内の Bun ディレクトリへのリンクになっている場合があります。`mise run install-bun` は、旧構成が所有していると確認できたリンクだけを実行用ディレクトリへ置き換え、既存の `node_modules/` を移します。別の場所を指すリンクや通常ファイルは変更しません。

### Homebrew

- 不足している Brewfile 依存関係を導入する場合は `mise run install-brew`
- Homebrew の導入は `mise bootstrap` と `mise run install` に含めない
- `brew bundle check --file=config/tools/homebrew/Brewfile`

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

既存の通常ファイルや実ディレクトリは競合として保護されます。既存のシンボリックリンクは、mise の標準仕様に従って宣言した配備元へ変更される場合があります。競合を一括で上書きする `--force` は、通常運用では使いません。

## 配備処理のテスト

```sh
mise run test-deployment
```

このタスクは Go テストを実行します。一時的な `HOME` と関連する状態ディレクトリを使い、実際の mise による配備、競合、冪等性、OS 別宣言、APM と Bun の移行を確認します。実際のホームディレクトリは変更しません。

配備や移行の Go コードを変更した場合は、データ競合と静的な問題も確認します。

```sh
mise exec -- go test -race ./tests
mise exec -- go vet ./tests
```

## 管理対象を削除する場合

mise は過去の宣言を所有権台帳として保持しません。`[dotfiles]` から項目を削除する前に、`mise bootstrap dotfiles unapply` の対象を確認して不要なリンクを外します。宣言を先に削除した場合、mise はそのリンクが過去の管理対象だったか判断できません。

生成データを伴う移行では、単純な `unapply` だけで済ませません。データを退避し、所有元を確認する migration を用意します。

## フォーマットと全体確認

```sh
mise run format
uv run pre-commit run -a
```

`mise run format` は Lua、shell、JSON、JSONC、Markdown、YAML、TOML を整形します。広い変更やマージ前の確認では pre-commit も実行します。

## ドキュメント更新の判断

- セットアップや利用手順が変わる
  - `README.md` と `README-ja.md`
- リポジトリ全体の原則が変わる
  - `docs/`
- サブシステム固有の詳細規約が変わる
  - 実装に近いポリシーファイル
- エージェントの参照先が変わる
  - `AGENTS.md` と `AGENTS-ja.md`
