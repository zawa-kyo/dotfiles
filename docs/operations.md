# 運用と確認

## 目的

変更内容や影響範囲に応じた適切な動作確認・検証手順をまとめます。

## 基本方針

- 影響範囲が局所的な変更では、対象に近い最小限の検証を行う
- セットアップ処理や PATH、配備宣言に関わる変更では、Go の結合テストおよび `mise run check` を実行する
- 実際のホームディレクトリへ反映する前に、状態確認（status）または dry-run による事前検証を行う
- ドキュメントのみの修正では重いテストを実行せず、フォーマット確認のみとする

## 変更種別ごとの確認

### ドキュメントのみ

- `mise run format` を実行する

### Neovim 設定

- Lua やフォーマッタ対象ファイルを変更した場合は `mise run format` を実行する
- プラグイン、provider、runtime 設定を変更した場合は `nvim` 内で `:checkhealth` を実行する

### シェルスクリプト、タスク、端末設定

- `mise run format` を実行する
- Bash または sh スクリプトを変更した場合は `mise run check-shell` を実行する
- セットアップ、PATH、公開コマンド、配備宣言に関わる場合は `mise run test-deployment` を実行する
- 影響範囲が広い場合は `mise run check` を実行する

### Bun

- `mise run install-bun` を実行する
- `bunx --version` で依存関係の解決を確認する
- `setup/bun/node_modules/` がリポジトリ内に生成されていないことを確認する

### mise

- グローバル設定の `auto_update = true` により standalone 版を定期的に自動更新する
- standalone 版を手動で更新する場合は `mise self-update` を使う
- 削除前には `mise implode --dry-run` で対象を確認する

> [!NOTE]
> 対話シェルでは、プロンプトを表示するたびに `mise hook-env` が実行されないよう、mise が登録する `precmd` フックを解除しています。`chpwd` フックは維持されるため、ディレクトリを移動した際は移動先の設定が反映されます。同一ディレクトリ内で `mise.toml` などを編集した場合は自動反映されないため、`cd .` を実行するか、`eval "$(mise hook-env --force -s zsh)"` で手動更新してください。

### Homebrew

- 不足している Brewfile の依存関係を導入する場合は `mise run install-brew` を実行する
- Homebrew の導入処理は `mise bootstrap` や `mise run install` に含めない
- `brew bundle check --file=setup/homebrew/Brewfile` を実行する

## 配備状態の確認

実際のホームディレクトリを変更することなく、現在の配備状態を事前に確認できます。

```sh
mise bootstrap dotfiles status
mise bootstrap dotfiles status --missing
mise bootstrap dotfiles apply --dry-run
```

`status` は各配備先の状態を表示します。`status --missing` は不足や不一致がある場合にエラー終了します。`apply --dry-run` は、適用時に行われる変更内容や競合を確認するために使用します。

確認後にリンクを反映します。

```sh
mise bootstrap dotfiles apply --yes
```

競合発生時の挙動については、[mise bootstrap 設計](./bootstrap-design.md#競合の扱い) を参照してください。競合を一括上書きする `--force` オプションは、通常の運用では使用しません。

## 配備処理のテスト

```sh
mise run test-deployment
```

このタスクは Go による結合テストを実行します。一時的な `HOME` ディレクトリと専用の状態ディレクトリを使用し、実際の mise コマンドによるリンク配備、競合処理、再実行時の冪等性、OS 別宣言の分岐、APM および Bun のデータ移行を検証します。開発機の実環境（ホームディレクトリ）は一切変更されません。

配備や移行に関わる Go のコードを変更した場合は、データ競合や静的解析のチェックも実行します。

```sh
mise exec -- go test -race ./tests
mise exec -- go vet ./...
```

## dotfiles の配備を解除する場合

解除対象を dry-run で事前に確認してから実行します。

```sh
mise bootstrap dotfiles unapply --dry-run
mise bootstrap dotfiles unapply --yes
```

`unapply` は、現在の `[dotfiles]` 宣言とファイルシステムの状態に基づき、mise が管理中と判定できる対象のみを削除します。`symlink-each` の配備先にある管理外のファイルはそのまま残ります。配備後に内容が編集された `copy` ファイルが存在する場合、ユーザーの変更を保護するために操作全体が中断されます。必要な変更を配備元のファイルに反映するか、配備元と同一の内容に戻した上で再実行してください。変更済みのファイルまで強制削除する `--force` は、通常の初期化には使用しません。

この操作で解除されるのは dotfiles のシンボリックリンク配備のみです。bootstrap タスクで導入されたツール本体、パッケージ、生成データは保持されます。なお、hk によるグローバルな Git hook 設定は `.gitconfig` の配備に含まれているため、`.gitconfig` を解除すると hook も自動的に無効化されます。dotfiles を再配備する場合は `mise bootstrap dotfiles apply --yes`、セットアップ全体を再実行する場合は `mise bootstrap --yes` を実行します。

`[dotfiles]` から特定の項目を削除する場合は、宣言を削除する前に対象パスを指定してリンクを解除します。

```sh
mise bootstrap dotfiles unapply --dry-run ~/.zshrc
mise bootstrap dotfiles unapply --yes ~/.zshrc
```

生成データの移行を伴う変更では、単純な `unapply` だけでは対応できません。データを適切に退避し、本リポジトリが作成したファイルのみを安全に変更する migration スクリプトを用意します。

## フォーマットと全体確認

```sh
mise run format
mise run check
```

`mise run format` は Go、Lua、Shell、JSON、JSONC、Markdown、YAML、TOML を対象に自動整形を行います。`mise run check` は hk を起点として各フォーマッタ、`go vet`、ShellCheck、Gitleaks、Git の差分などを網羅的に検査します。Git pre-commit hook ではステージ済みのファイルを対象とし、手動実行時は追跡対象ファイル全体を検査します。

## ドキュメント更新の判断基準

- セットアップや利用手順が変わる場合:
  - `README.md` と `README-ja.md`
- リポジトリ全体の設計原則が変わる場合:
  - `docs/`
- サブシステム固有の詳細規約が変わる場合:
  - 実装に近いポリシーファイル
- エージェントの参照先が変わる場合:
  - `AGENTS.md` と `AGENTS-ja.md`
