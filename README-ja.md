# 🏠 dotfiles

エディタ、ターミナル、CLI ツール、ローカルツールチェーンを管理する dotfiles リポジトリです。

この README では、初回セットアップとよく使うコマンドを扱います。
設計や運用は `docs/`、エージェント向けの案内は `AGENTS.md` を確認してください。

## ✨ 管理対象

- Neovim と VS Code のエディタ設定
- Zsh、Starship、Ghostty、WezTerm、Zellij などのターミナル周辺設定
- Karabiner-Elements で使う macOS のキーボード設定
- Homebrew、Bun、mise、procs などのローカルツール設定
- `bin/` で公開する単独実行 CLI コマンド
- Codex や Claude Code などで使う AI ツール設定
- エディタと LSP の動作確認に使うサンプルファイル

## 🚀 クイックスタート

リポジトリをクローンして作業ディレクトリへ移動します。

```sh
git clone [repository_url]
cd [cloned_repository_path]
```

公式インストーラを使い、最新版の standalone 版 `mise` を導入します。インストーラは `~/.local/bin/mise` にバイナリを配置します。

```sh
curl https://mise.run | sh
```

Homebrew 版から移行する場合は、standalone 版の導入後にシェルを再起動します。現在のシェルには、`/opt/homebrew/bin/mise` を参照する有効化処理が残っていることがあります。

```sh
exec zsh -l
mise --version
```

リポジトリを信頼済みにしてから、セットアップを実行します。

```sh
~/.local/bin/mise trust
~/.local/bin/mise bootstrap --yes
```

このコマンドでは、次の作業をまとめて行います。

- `mise.toml` と OS 別設定に宣言した dotfiles の反映
- mise 管理ツールのインストール
- apm 管理スキルの反映
- Bun グローバル環境の準備
- hk のグローバルな Git pre-commit hook 設定の配備

hk の hook は Git の設定による hook 機能を使うため、Git 2.54 以降が必要です。`hk.pkl` がないリポジトリでは何も実行しません。

`mise run install` は `mise bootstrap` の互換入口として残しています。
どちらのコマンドも Homebrew パッケージはインストールしません。macOS で Brewfile の不足分を導入する場合は、`mise run install-brew` を明示的に実行します。

以前のセットアップで Homebrew 版の mise を導入していた場合は、standalone 版の導入後に Homebrew 版を削除します。

```sh
brew uninstall mise
```

standalone 版のバイナリと mise が管理するデータを削除する場合は、対象を確認してから `mise implode` を実行します。`--config` を付けない限り、`~/.config/mise` は残ります。

```sh
mise implode --dry-run
mise implode
```

## 🛠️ よく使うコマンド

| コマンド                                    | 用途                                                                 |
| ------------------------------------------- | -------------------------------------------------------------------- |
| `mise bootstrap`                            | 標準のローカルセットアップを実行する                                 |
| `mise bootstrap dotfiles status`            | ファイルを変更せず、宣言した配備先の状態を確認する                   |
| `mise bootstrap dotfiles apply --dry-run`   | dotfiles の変更と競合を事前に確認する                                |
| `mise bootstrap dotfiles apply --yes`       | 宣言した dotfiles のリンクを反映する                                 |
| `mise bootstrap dotfiles unapply --dry-run` | dotfiles の配備解除を事前に確認する                                  |
| `mise bootstrap dotfiles unapply --yes`     | mise が管理中と判定できる dotfiles の配備を解除する                  |
| `mise self-update`                          | standalone 版の mise をすぐに更新する                                |
| `mise run format`                           | Git の追跡対象ファイルを整形する                                     |
| `mise run check`                            | リポジトリ全体の検査を実行する                                       |
| `mise run install-brew`                     | macOS で Brewfile の不足分をインストールする                         |
| `mise run test-deployment`                  | 一時的なホームディレクトリで bootstrap の動作を確認する              |
| `mise run --continue-on-error upgrade`      | mise 管理ツール、apm、Neovim、Bun と、macOS では Homebrew を更新する |
| `mise tasks`                                | 利用できる mise タスクを一覧する                                     |

`bin/` のコマンドはグローバルにリンクします。
このディレクトリには、Git 操作やタスク検索など日常作業で直接使う小さな CLI ツールを置いています。

配備されるグローバル mise 設定では、自動更新を有効にしています。mise は、通信を行える対話的なコマンドの実行前に、新しいリリースがあるか定期的に確認します。一時的に止める場合は `MISE_AUTO_UPDATE=false` を指定します。

### Bun グローバルパッケージ

Bun のグローバル環境で使う `package.json`、`bun.lock`、`bunfig.toml` は `setup/bun/` で管理します。
`mise run install-bun` はこれらのファイルを `~/.bun/install/global` へコピーし、依存関係を同じディレクトリへインストールします。生成される `node_modules/` はリポジトリ内に置きません。
`mise run upgrade-bun` は実行用ディレクトリで依存関係を更新し、変更されたパッケージ宣言と lock ファイルを `setup/bun/` へ戻します。

### Git worktree

ghq で取得したリポジトリの worktree は Worktrunk で管理します。新しい worktree は元のリポジトリと同じ階層に作成し、worktree を削除してもブランチは残します。

| コマンド               | 用途                                                 |
| ---------------------- | ---------------------------------------------------- |
| `wt switch --branches` | worktree またはローカルブランチを選択して移動する    |
| `wt switch --remotes`  | リモートブランチも含めて worktree の移動先を選択する |
| `wt list`              | worktree と状態を一覧表示する                        |
| `wt remove`            | ブランチを残したまま現在の worktree を削除する       |

## 🗂️ リポジトリ構成

| パス        | 役割                                             |
| ----------- | ------------------------------------------------ |
| `dotfiles/` | ホームディレクトリへリンクする設定               |
| `bin/`      | `~/.local/bin` へ公開する単独実行 CLI コマンド   |
| `libexec/`  | 公開コマンドから使う非公開の補助処理             |
| `setup/`    | 環境構築用の宣言、スクリプト、migration          |
| `tests/`    | 一時的なホームディレクトリを使う Go の結合テスト |
| `docs/`     | リポジトリ全体の設計と運用ポリシー               |

## 📚 詳細ドキュメント

README は概要に留め、詳しい設計や運用は次のドキュメントに分けています。

- [docs/index.md](docs/index.md): ドキュメントの入口
- [docs/architecture.md](docs/architecture.md): ディレクトリ構成と責務境界
- [docs/bootstrap-design.md](docs/bootstrap-design.md): mise bootstrap の責務と移行規則
- [docs/command-model.md](docs/command-model.md): グローバルコマンド、シェル関数、mise タスクの使い分け
- [docs/abbreviation.md](docs/abbreviation.md): シェルの省略コマンドと Neovim キーバインドに共通する命名方針
- [docs/ai-tools.md](docs/ai-tools.md): AI ツールと apm の運用方針
- [docs/operations.md](docs/operations.md): 変更内容に応じた確認方法

Neovim 固有の方針は `dotfiles/editors/nvim/lua/policies/` に置いています。
