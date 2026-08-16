# mise bootstrap 設計

## 目的

dotfiles の定常的な配備を mise の標準機能へ寄せ、リポジトリ固有コードを旧構成の移行と依存関係の準備に限定します。

## 責務境界

| 責務                           | 管理場所                          |
| ------------------------------ | --------------------------------- |
| 共通の dotfiles 宣言           | `mise.toml` の `[dotfiles]`       |
| macOS 固有の dotfiles 宣言     | `mise.macos.toml` の `[dotfiles]` |
| 配備前に必要な旧構成の移行     | `setup/migrations/`               |
| 配備後のツールや依存関係の導入 | `mise.toml` の bootstrap タスク   |
| Homebrew 依存関係の導入        | 明示的な `mise run install-brew`  |
| 配備と移行の結合テスト         | `tests/` の Go テスト             |

`mise bootstrap` を正式な入口とし、`mise run install` は同じ処理を呼ぶ互換入口に留めます。独自の配備マニフェスト、所有権台帳、`apply`・`check`・`diff` の再実装は持ちません。

## 配備モード

単独のファイルや、全体を同じ単位で管理する設定ディレクトリは通常のシンボリックリンクにします。

`~/.local/bin` と `~/.apm` は `symlink-each` を使い、管理外の隣接ファイルを残します。

配備先のツールが実ファイルを書き換える場合は `copy`、リポジトリだけで編集する場合はシンボリックリンクを使います。`~/.apm` では `symlink-each` から `apm.lock.yaml` を除外して同じファイルを `copy` で宣言し、`apm_modules/` などの生成物は管理対象に含めません。

## 競合の扱い

mise の標準動作を次のように採用します。

- 宣言どおりのリンクは変更しない
- 配備先が存在しなければリンクを作る
- 既存の通常ファイルや実ディレクトリは競合として保護する
- 既存のシンボリックリンクは宣言した配備元へ収束させる
- `symlink-each` の配備先にある管理外の隣接項目は削除しない

旧方式とはシンボリックリンクの扱いが異なります。定常的な配備では mise の仕様を正とし、管理外リンクを独自判定で保護する互換処理は追加しません。ただし、APM の生成データを移動する pre-dotfiles migration は、旧リポジトリ内を指すと確認できたリンクだけを変更します。データ移行で所有権を誤認すると復旧が難しいためです。

## 状態確認と変更

```sh
mise bootstrap dotfiles status
mise bootstrap dotfiles status --missing
mise bootstrap dotfiles apply --dry-run
mise bootstrap dotfiles apply --yes
```

`status` と `apply --dry-run` は変更前の確認に使います。`status --missing` は不足や不一致があれば失敗するため、確認処理にも利用できます。

mise は全配備モードに共通する所有権台帳を持ちませんが、`symlink-each` が作成したリンクは `$MISE_STATE_DIR/dotfiles` に記録します。`[dotfiles]` の宣言を削除する場合は、先に `mise bootstrap dotfiles unapply` の対象を確認します。この順序を守れない変更では、所有元を狭く判定できる一時的な migration を用意します。

## bootstrap の実行順序

1. pre-dotfiles hook で旧構成の APM データと生成済みラッパーを移行する
2. mise が `[dotfiles]` を反映する
3. post-dotfiles hook で、配備したグローバル mise 設定だけを信頼する
4. mise がリポジトリ内のツールをインストールする
5. 共通の bootstrap タスクでグローバル mise ツール、apm、Bun、Lefthook を準備する

各処理は再実行できることを前提にします。移行処理は、移行済みなら変更せず、管理元を確認できないパスでは失敗します。途中で失敗した場合は診断を確認して原因を直し、`mise bootstrap` を再実行します。`--force` で競合を一括上書きする運用は標準手順にしません。

初回セットアップは `mise trust`、`mise bootstrap --yes` の順に実行します。post-dotfiles hook は、信頼済みのリポジトリから配備したグローバル mise 設定だけを後続処理のために信頼します。

Homebrew の導入は bootstrap に含めません。
Brewfile は、明示的に実行する `mise run install-brew` と `mise run --continue-on-error upgrade` から扱います。
これにより、標準セットアップは Homebrew の状態に左右されません。

## テスト方針

Go の標準ライブラリから実際の mise と移行スクリプトを子プロセスとして実行します。テスト用の `HOME` と、移行処理が参照するすべての `DIR_*` を一時ディレクトリへ向け、実環境を読み書きしない境界を作ります。

主なシナリオは次のとおりです。

- 宣言したリンクと `symlink-each` の追加型配備
- 通常ファイルの保護とシンボリックリンクの収束
- 2 回目の適用で結果が変わらないこと
- 共通設定と macOS 固有設定の分離
- APM と Bun の生成データ移行
- apm が lock ファイルを通常ファイルとして書き直した後の再適用
- apm の更新結果をリポジトリの lock ファイルへ戻す経路
- 旧構成が所有していない APM リンクの拒否
- 生成済みラッパーだけを削除し、利用者のファイルを残すこと
- 公開コマンドのラッパーが実在する拡張子なしの入口を参照すること

テストは mise の配備ロジックを再実装せず、外部入口とファイルシステム上の結果を検査します。Go は検証用ツールとして `mise.toml` に宣言しますが、dotfiles の配備そのものは Go に依存しません。
