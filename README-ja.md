# 🚀 dotfiles

エディタ、ターミナル、CLI ツール、ローカルツールチェーンを管理する dotfiles リポジトリです。

この README では、初回セットアップと日常的によく使うコマンドをまとめています。
設計方針や運用の詳細は `docs/`、エージェント向けの案内は `AGENTS.md` を確認してください。

## 管理対象

- Neovim と VS Code のエディタ設定
- Zsh、Starship、Ghostty、WezTerm、Zellij などのターミナル周辺設定
- Karabiner-Elements を使った macOS のキーボード設定
- Homebrew、Bun、mise、procs などのローカルツール設定
- `bin/` で公開する単独実行 CLI コマンド
- Codex や Claude Code などで使う AI ツール設定
- エディタと LSP の動作確認用サンプルファイル

## クイックスタート

リポジトリをクローンして作業ディレクトリへ移動します。

```sh
git clone [repository_url]
cd [cloned_repository_path]
```

公式インストーラを使って standalone 版 `mise` の最新バイナリを導入します。バイナリは `~/.local/bin/mise` に配置されます。

```sh
curl https://mise.run | sh
```

Homebrew 版から移行する場合は、standalone 版を導入したあとにシェルを再起動します。現在のシェル環境に `/opt/homebrew/bin/mise` を参照する設定が残っている場合があるためです。

```sh
exec zsh -l
mise --version
```

リポジトリを信頼済みにしてから、セットアップを実行します。

```sh
~/.local/bin/mise trust
~/.local/bin/mise bootstrap --yes
```

このコマンドを実行すると、次の処理がまとめて行われます。

- `mise.toml` と OS 別設定に宣言された dotfiles の反映
- mise 管理ツールのインストール
- apm 管理スキルの反映
- Bun グローバル環境の準備
- hk によるグローバルな Git pre-commit hook 設定の配備

hk の hook は Git の設定ベースの hook 機能を利用するため、Git 2.54 以降が必要です。`hk.pkl` が存在しないリポジトリでは何も実行されずに終了します。

`mise run install` は `mise bootstrap` の互換エイリアスとして残されています。
どちらのコマンドも Homebrew パッケージ自体のインストールは行いません。macOS で Brewfile の不足分を導入する場合は、明示的に `mise run install-brew` を実行してください。

以前の環境で Homebrew 経由で mise をインストールしていた場合は、standalone 版の導入後に Homebrew 版をアンインストールします。

```sh
brew uninstall mise
```

standalone 版のバイナリや mise が管理するデータを削除する場合は、対象を確認した上で `mise implode` を実行します。`--config` を指定しない限り、`~/.config/mise` は保持されます。

```sh
mise implode --dry-run
mise implode
```

## よく使うコマンド

| コマンド                                    | 用途                                                                 |
| ------------------------------------------- | -------------------------------------------------------------------- |
| `mise bootstrap`                            | 標準のローカルセットアップを実行する                                 |
| `mise bootstrap dotfiles status`            | ファイルを変更せずに、宣言された配備先の状態を確認する               |
| `mise bootstrap dotfiles apply --dry-run`   | dotfiles の変更内容と競合を事前に確認する                            |
| `mise bootstrap dotfiles apply --yes`       | 宣言された dotfiles のリンクを反映する                               |
| `mise bootstrap dotfiles unapply --dry-run` | dotfiles の配備解除を事前に確認する                                  |
| `mise bootstrap dotfiles unapply --yes`     | mise が管理中と判定できる dotfiles の配備を解除する                  |
| `mise self-update`                          | standalone 版の mise を最新版に更新する                              |
| `mise run format`                           | Git の追跡対象ファイルを整形する                                     |
| `mise run check`                            | リポジトリ全体の検査を実行する                                       |
| `mise run install-brew`                     | macOS で Brewfile の不足分をインストールする                         |
| `mise run test-deployment`                  | 一時的なホームディレクトリで bootstrap の動作を検証する              |
| `mise run --continue-on-error upgrade`      | mise 管理ツール、apm、Neovim、Bun と、macOS では Homebrew を更新する |
| `mise tasks`                                | 利用可能な mise タスクを一覧表示する                                 |

`bin/` 配下のコマンドは、セットアップ時にグローバルへリンクされます。
ここには、Git 操作やタスク検索など、日常の作業で直接使う軽量な CLI ツールを配置しています。

配備されるグローバル mise 設定では、自動更新が有効になっています。mise は、通信を伴う対話的なコマンドの実行前に、新しいリリースがないか定期的に確認します。この確認を一時的に無効化したい場合は `MISE_AUTO_UPDATE=false` を指定します。

### Bun グローバルパッケージ

Bun のグローバル環境で使う `package.json`、`bun.lock`、`bunfig.toml` は `setup/bun/` で管理します。
`mise run install-bun` はこれらのファイルを `~/.bun/install/global` へコピーした上で依存関係をインストールするため、生成される `node_modules/` がリポジトリ内に混入することはありません。
`mise run upgrade-bun` は実行用ディレクトリで依存関係を更新し、更新されたパッケージ定義と lock ファイルを `setup/bun/` へ書き戻します。

### Git worktree

ghq で取得したリポジトリの worktree は Worktrunk で管理します。新しい worktree は元のリポジトリと同じ階層に作成され、worktree を削除してもブランチ自体は保持されます。

| コマンド               | 用途                                                 |
| ---------------------- | ---------------------------------------------------- |
| `wt switch --branches` | worktree またはローカルブランチを選択して切り替える  |
| `wt switch --remotes`  | リモートブランチも含めて worktree の移動先を選択する |
| `wt list`              | worktree とその状態を一覧表示する                    |
| `wt remove`            | ブランチを残したまま現在の worktree を削除する       |

## リポジトリ構成

| パス        | 役割                                             |
| ----------- | ------------------------------------------------ |
| `dotfiles/` | ホームディレクトリへリンクする設定               |
| `bin/`      | `~/.local/bin` へ公開する単独実行 CLI コマンド   |
| `libexec/`  | 公開コマンドから使う非公開の補助処理             |
| `setup/`    | 環境構築用の宣言、スクリプト、migration          |
| `tests/`    | 一時的なホームディレクトリを使う Go の結合テスト |
| `docs/`     | リポジトリ全体の設計と運用ポリシー               |

## 詳細ドキュメント

この README では概要のみを記載しています。設計思想や運用手順などの詳細なドキュメントは、[docs/README.md](./docs/README.md) を目次として参照してください。
