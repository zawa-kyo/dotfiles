# fnox による秘密情報の管理

## 目的と対象

`~/local.d/` に平文で保存しているアクセストークンなどを `fnox` 経由で参照する構成へ移行する。
Bitwarden Password Manager を使う端末では Bitwarden を管理元とし、使わない端末では端末固有の age 暗号文を使う。
利用側はどちらの端末でも同じ秘密情報名を参照する。

今回の対象は、端末全体で使う個人用の秘密情報である。
プロジェクト固有の秘密情報、CI/CD、Bitwarden Secrets Manager、`~/local.d/` の秘密情報以外の設定は対象外とする。
秘密情報の値は暗号文を含めて、このリポジトリでは管理しない。

## 現状と前提

現状は `dotfiles/tools/mise/conf.d/env.toml` が `DIR_LOCAL_CONFIG` を `~/local.d` に設定し、シェルの省略入力もこの変数を参照している。
リポジトリ内に `~/local.d/` の秘密情報を読み込む処理は見つかっていない。
実際の利用側と対象の秘密情報は、移行時に端末上で調査する。
調査結果に応じて、秘密情報以外の `local.d` 設定と `DIR_LOCAL_CONFIG` は残す。

`fnox` は実行ディレクトリから親ディレクトリへ設定を探索し、ユーザー単位の `~/.config/fnox/config.toml` を常に読み込む。
このため、dotfiles ルートの `fnox.toml` だけでは、ほかの作業ディレクトリで実行するコマンドに個人用の秘密情報を提供できない。

## 設定の配置

全端末で `~/.config/fnox/config.toml` を使用する。
このファイルは Git 管理せず、端末ごとに provider と秘密情報の定義を持つ。
設定ファイルには Bitwarden の参照先、または age で暗号化した値が入る。
age の identity は `~/.config/fnox/age.txt` に置き、Git 管理しない。

```text
利用側のコマンド
    ↓ fnox exec / fnox get
fnox のユーザー単位設定
    ├─ Bitwarden を使う端末 → bw → Bitwarden
    └─ Bitwarden を使わない端末 → age → ユーザー単位設定の暗号文
```

リポジトリには `fnox` のインストール宣言と運用手順のみを置く。
秘密情報名を共有する必要が判明した場合も、値や端末固有の参照先を含まない一覧として管理する。
プロジェクト側に `fnox.toml` がある場合、その定義はユーザー単位の同名定義より優先される。
衝突する名前は移行時に確認する。

### Bitwarden を使わない端末

端末上の `~/.config/fnox/config.toml` に age provider を定義する。
`recipients` には、その端末の identity に対応する公開鍵を指定する。

```toml
env = "exec"

[providers.local]
type = "age"
recipients = ["age1..."]
key_file = "~/.config/fnox/age.txt"
```

秘密情報は `fnox set SECRET_NAME --global --provider local` で対話的に登録する。
`--global` を省くと、現在のディレクトリの設定に書き込まれる可能性がある。
値をコマンドの引数に渡さず、非表示の入力欄から登録する。
`fnox set` は provider を指定しないと平文の既定値を書き込むため、必ず `--provider local` を付ける。

### Bitwarden を使う端末

端末上の `~/.config/fnox/config.toml` に Bitwarden provider と参照先を定義する。
参照先の項目名は実際に作成した Bitwarden の項目に合わせる。
ログイン項目のパスワード欄を参照する例は次のとおり。

```toml
env = "exec"

[providers.bitwarden]
type = "bitwarden"

[secrets]
GITHUB_TOKEN = { provider = "bitwarden", value = "GitHub Token/password" }
```

`bw` CLI でログインし、利用するシェルで vault を解除する。

```sh
bw login
export BW_SESSION="$(bw unlock --raw)"
```

`BW_SESSION` を dotfiles や平文ファイルへ永続保存しない。
Bitwarden の項目を更新した後は、必要に応じて `bw sync` を実行してから `fnox` で確認する。

### オフライン利用

Bitwarden を使う端末でオフライン利用が必要な場合だけ、ユーザー単位の設定に別名の age provider `sync-age` を追加する。
同期先には同じ端末の公開鍵を設定する。

```toml
[providers.sync-age]
type = "age"
recipients = ["age1..."]
key_file = "~/.config/fnox/age.txt"
```

```sh
fnox sync --global --provider sync-age --source bitwarden --dry-run
fnox sync --global --provider sync-age --source bitwarden
```

`fnox sync` は Bitwarden から取得した値を age で暗号化し、各秘密情報の `sync` フィールドに保存する。
参照時は同期した値が優先されるため、Bitwarden の更新は再同期するまで反映されない。
再同期時は `fnox sync --global --provider sync-age --source bitwarden --force` を実行する。
オフライン確認後も、古いキャッシュが残らないよう更新手順を運用に含める。

`--local-file` はプロジェクトの `fnox.toml` に隣接する `fnox.local.toml` へ書く場合に使う。
今回の対象はユーザー単位の秘密情報なので、`--global` を使い、`fnox.local.toml` は作らない。

## 利用側と mise

`fnox` は既存の mise のツール一覧 `dotfiles/tools/mise/conf.d/tools.toml` に追加する。
`mise use -g fnox` はこのリポジトリの宣言とは別のユーザー単位設定を書き換えるため、移行手順には使わない。
Bitwarden を使う端末には `bw` CLI、age identity の生成には `age-keygen` が必要である。
導入方法は対象端末の既存のセットアップ方針に合わせて実装時に決める。

秘密情報が必要なコマンドは `fnox exec -- <command>` で起動する。
単一値を明示的に使う場合に限り `fnox get <SECRET_NAME>` を使う。
`fnox get` は値を標準出力へ出すため、確認時は表示先とログに注意する。
普段のシェルへ一律に秘密情報を注入する要件は現時点でないため、設定例では `env = "exec"` とし、シェル統合は導入しない。
必要になった場合は、対象の秘密情報と利用側を特定してから検討する。
実験的な `mise-env-fnox` plugin は使わない。

## 移行手順

1. **対象を調査する。** `~/local.d/` のファイルと、その読み込み元を端末上で確認する。値を表示・記録せず、秘密情報名、利用側、非秘密情報の区別を記録する。リポジトリ内の `local.d` 参照だけで移行対象を確定しない。
2. **`fnox` と age を準備する。** mise のツール一覧に `fnox` を追加し、対象端末で利用可能にする。端末ごとに `~/.config/fnox/` を作り、`age-keygen -o ~/.config/fnox/age.txt` で identity を作る。公開鍵は `age-keygen -y ~/.config/fnox/age.txt` で確認する。既存の identity がある場合は上書きしない。
3. **まず 1 件を age に移す。** ユーザー単位の age provider を設定し、`fnox set GITHUB_TOKEN --global --provider local` などで登録する。別の作業ディレクトリから `fnox config-files` で設定の読み込みを確認し、`fnox exec -- sh -c 'test -n "$GITHUB_TOKEN"'` のように値を表示しない方法で解決を確認する。実際の利用側でも動作を確かめる。
4. **残りを移し、利用側を切り替える。** 各秘密情報を age に登録し、必要なコマンドを `fnox exec` 経由に変更する。秘密情報の取得を `bw` や age へ直接依存させない。新しいシェルで利用側が動作した秘密情報から、対応する `~/local.d/` の平文定義を削除する。
5. **Bitwarden 端末だけ管理元を切り替える。** 対象の値を Bitwarden に登録し、ユーザー単位の定義を Bitwarden の参照先へ変更する。各秘密情報の実利用を確認してから、同じ端末の旧 age 暗号文を設定から除く。Bitwarden を使わない端末の age 定義は維持する。値を複数端末で共有する運用が必要なら、更新手順もこの段階で定める。
6. **必要な端末だけ同期する。** `sync-age` を設定し、`fnox sync --global --provider sync-age --source bitwarden --dry-run` で対象を確認してから同期する。ネットワークを切った状態で取得と実利用を確認する。
7. **後片付けする。** `~/local.d/` に移行対象の平文が残っていないことを確認する。非秘密情報の利用が残る間は `DIR_LOCAL_CONFIG` とシェルの省略入力を維持する。実装が確定したら `README.md` と `README-ja.md`、必要な設計文書を更新する。

秘密情報の入力、平文定義の削除、Bitwarden への登録は所有者が対象端末上で行う。
移行中は 1 件ずつ取得と実利用を確認してから旧定義を削除する。
障害時は確認済みの旧定義を一時的に戻せるようにし、復旧後に再度削除する。
Bitwarden 側の障害では、残してある age の値へ一時的に戻す場合も、古い値かどうかを確認する。

## セキュリティと完了条件

- `~/.config/fnox/config.toml`、age identity、同期した暗号文は Git 管理しない。ファイルの権限とバックアップ先も確認する。
- age identity には所有者だけが読める権限を設定する。`chmod 600 ~/.config/fnox/age.txt` を目安とする。
- 秘密情報の値をコマンド引数、シェル履歴、ログ、レビュー用の差分に含めない。
- `fnox exec` は子プロセスの環境へ秘密情報を渡す。子プロセスが環境変数を記録・送信する可能性も、利用側の確認に含める。
- 同じ端末に age 暗号文と復号鍵を置く構成は、その端末を操作できる第三者から値を守るものではない。平文ファイルとバックアップへの混入を減らすことが主な効果である。

移行完了の条件は次のとおり。

- [ ] 対象端末の必要な秘密情報を、作業ディレクトリによらず `fnox` で解決できる。
- [ ] 主要な利用側が `fnox exec` 経由で動作する。
- [ ] Bitwarden を使う端末は Bitwarden の参照先を管理元とし、使わない端末は age で取得できる。
- [ ] オフライン利用が必要な端末では、同期後にネットワークなしで実利用できる。
- [ ] `~/local.d/` に移行対象の平文定義が残っていない。
- [ ] identity とユーザー単位の設定が Git 管理されていない。

## 実装の分割

最初の変更では、mise への `fnox` 追加、ユーザー単位の age 設定手順、1 件の移行と利用側の確認まで進める。
続いて残りの秘密情報と利用側を移し、平文定義を削除する。
Bitwarden への切り替えとオフライン同期は、それぞれ確認できる単位で別に進める。

## 参照資料

- [fnox の設定ファイルと優先順位](https://fnox.jdx.dev/reference/configuration.html)
- [fnox の階層的な設定の読み込み](https://fnox.jdx.dev/guide/hierarchical-config.html)
- [age provider](https://fnox.jdx.dev/providers/age.html)
- [Bitwarden provider](https://fnox.jdx.dev/providers/bitwarden.html)
- [`fnox set`](https://fnox.jdx.dev/cli/set.html)
- [`fnox sync`](https://fnox.jdx.dev/cli/sync.html)
- [fnox と mise の連携](https://fnox.jdx.dev/guide/mise-integration.html)
