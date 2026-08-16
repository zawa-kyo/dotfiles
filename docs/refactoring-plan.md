# リファクタリング計画

## 位置づけ

この文書は、独自の配備処理から mise bootstrap へ移行した判断と、残っている TODO を記録します。現在の利用方法は `README.md`、定常設計は `docs/architecture.md` と `docs/bootstrap-design.md` を参照してください。

## 結論

配備先を写した `home/`、`macos/`、パッケージ宣言を分けた `packages/` は、リンク先を推測しやすい一方、同じツールに関する変更が複数の最上位ディレクトリへ分散していました。

現在は、管理対象を起点に `config/ai/`、`config/editors/`、`config/shell/`、`config/terminal-apps/`、`config/tools/` へまとめています。配備先との対応は mise の `[dotfiles]` で明示します。この方式では一覧を読む必要がありますが、日常的な変更の探索範囲と独自配備コードを減らせます。

定常的なリンク処理は mise の仕様を採用し、通常ファイルと実ディレクトリを保護しながら、既存のシンボリックリンクは宣言した配備元へ収束させます。旧方式と同じ所有判定を再実装する後方互換層は設けません。生成データを伴う旧構成の移行だけは、所有元を確認できる対象に限定した migration を残します。

配備の結合テストには Go を採用しました。Go の標準ライブラリでファイルシステム、子プロセス、一時ディレクトリを扱い、実際の mise と shell migration の外部入口を検査します。Go は検証時だけ必要で、dotfiles の反映そのものには不要です。

## 完了した変更

- [x] 設定とパッケージ宣言を管理対象別の `config/` へ移す
- [x] 共通宣言を `mise.toml`、macOS 固有宣言を `mise.macos.toml` へ分ける
- [x] 初回セットアップを `mise bootstrap` に集約する
- [x] `mise run install` を互換入口として残す
- [x] `bin/` のコマンド名から拡張子を外し、`symlink-each` で `~/.local/bin` へ公開する
- [x] APM の宣言と生成データ、Bun の宣言と実行用ディレクトリを分離する
- [x] 旧構成の APM データと生成済み mise ラッパーを安全に移行する
- [x] 独自の配備一覧と `apply`・`check`・`diff` 実装を削除する
- [x] Go の結合テストで配備、競合、冪等性、OS 別宣言、APM と Bun の移行を確認する
- [x] テストの `HOME` と移行用 `DIR_*` を一時領域へ隔離する
- [x] Go を mise の検証用ツールとして宣言し、macOS arm64 と Linux x64 のロック情報を記録する
- [x] 検証した mise 2026.8.4 を最低バージョンとして明示する
- [x] 配備したグローバル mise 設定だけを tools 導入前に信頼する
- [x] README、設計、運用、エージェント向け参照を実装結果へ合わせる

## 維持する境界

- `[dotfiles]` は現在の宣言とファイルシステムから状態を判断し、独自の所有権台帳を追加しない
- `symlink-each` は、`~/.local/bin` と `~/.apm` にある管理外の隣接項目を残すために使う
- 管理対象を削除するときは、宣言を消す前に `unapply` の対象を確認する
- migration は旧構成が所有したと確認できるパスだけを変更する
- bootstrap は再実行可能にし、競合を `--force` で一括上書きしない
- テストは mise の配備ロジックや production の所有判定を再実装しない
- Python へ依存する検証環境は持たず、Lefthook と既存の検査ツールを直接実行する

## 残っている TODO

### 導入後の確認

- [ ] 実際のホームディレクトリで `mise bootstrap dotfiles apply --dry-run` の結果を確認する
- [ ] 利用者の承認後に `mise bootstrap` を実行し、2 回目の実行で意図しない変更がないことを確認する
- [ ] Linux 環境で共通宣言と bootstrap タスクを実行し、macOS 固有設定が読み込まれないことを確認する

### 互換処理の終了条件

- [ ] `mise run install` の互換入口を削除する時期を、利用箇所の確認後に決める
- [ ] 旧 APM 構成と生成済み mise ラッパーの移行完了を実機で確認する
- [ ] 移行対象が残っていないと確認できた後、`deploy/migrations/` と配備専用の `libexec/path.sh` を削除する

### 運用上の改善

- [ ] CI を導入する場合は `mise run test-deployment` と Linux の bootstrap dry-run を実行する
- [ ] 管理対象を削除する変更のレビュー項目に、`unapply` を先に行ったかを追加する

## 検証方針

実装時には次を基準にします。

```sh
mise run format
mise run check-shell
mise run test-deployment
mise exec -- go test -race ./tests
mise exec -- go vet ./tests
mise run check
```

実際のホームディレクトリへの適用はコード検証と分けます。
まず `mise bootstrap dotfiles status` で現在の状態を確認します。
次に `mise bootstrap dotfiles apply --dry-run` で競合と移行対象を確認してから適用します。
