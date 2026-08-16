# 🏠 dotfiles

エディタ、ターミナル、CLI ツール、ローカルツールチェーンを管理する dotfiles リポジトリです。

この README では、初回セットアップとよく使うコマンドを扱います。
設計や運用は `docs/`、エージェント向けの案内は `AGENTS.md` を確認してください。

## ✨ 管理対象

- Neovim と VS Code のエディタ設定
- Zsh、Starship、Ghostty、WezTerm、Zellij などのターミナル周辺設定
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

シェルで `mise` が使えない場合は先にインストールします。

```sh
brew install mise
```

セットアップは次のコマンドに集約しています。

```sh
mise bootstrap
```

このコマンドでは、次の作業をまとめて行います。

- `mise.toml` と OS 別設定に宣言した dotfiles の反映
- mise 管理ツールのインストール
- apm 管理スキルの反映
- Bun グローバル環境の準備
- Lefthook による Git pre-commit hook のインストール

`mise run install` は `mise bootstrap` の互換入口として残しています。
どちらのコマンドも Homebrew パッケージはインストールしません。macOS で Brewfile の不足分を導入する場合は、`mise run install-brew` を明示的に実行します。

## 🛠️ よく使うコマンド

| コマンド                                  | 用途                                                    |
| ----------------------------------------- | ------------------------------------------------------- |
| `mise bootstrap`                          | 標準のローカルセットアップを実行する                    |
| `mise bootstrap dotfiles status`          | ファイルを変更せず、宣言した配備先の状態を確認する      |
| `mise bootstrap dotfiles apply --dry-run` | dotfiles の変更と競合を事前に確認する                   |
| `mise bootstrap dotfiles apply --yes`     | 宣言した dotfiles のリンクを反映する                    |
| `mise run format`                         | Git の追跡対象ファイルを整形する                        |
| `mise run check`                          | リポジトリ全体の検査を実行する                          |
| `mise run install-brew`                   | macOS で Brewfile の不足分をインストールする            |
| `mise run test-deployment`                | 一時的なホームディレクトリで bootstrap の動作を確認する |
| `mise run upgrade`                        | mise、apm、Neovim、Bun、Homebrew の依存関係を更新する   |
| `mise tasks`                              | 利用できる mise タスクを一覧する                        |

`bin/` のコマンドはグローバルにリンクします。
このディレクトリには、Git 操作やタスク検索など日常作業で直接使う小さな CLI ツールを置いています。

### Bun グローバルパッケージ

Bun のグローバル環境で使う `package.json`、`bun.lock`、`bunfig.toml` は `config/tools/bun/` で管理します。
`mise run install-bun` はこれらのファイルを `~/.bun/install/global` へコピーし、依存関係を同じディレクトリへインストールします。生成される `node_modules/` はリポジトリ内に置きません。
`mise run upgrade-bun` は実行用ディレクトリで依存関係を更新し、変更されたパッケージ宣言と lock ファイルを `config/tools/bun/` へ戻します。

### Git worktree

ghq で取得したリポジトリの worktree は Worktrunk で管理します。新しい worktree は元のリポジトリと同じ階層に作成し、worktree を削除してもブランチは残します。

| コマンド               | 用途                                                 |
| ---------------------- | ---------------------------------------------------- |
| `wt switch --branches` | worktree またはローカルブランチを選択して移動する    |
| `wt switch --remotes`  | リモートブランチも含めて worktree の移動先を選択する |
| `wt list`              | worktree と状態を一覧表示する                        |
| `wt remove`            | ブランチを残したまま現在の worktree を削除する       |

## 🗂️ リポジトリ構成

| パス       | 役割                                                    |
| ---------- | ------------------------------------------------------- |
| `config/`  | 管理するツールまたは領域ごとにまとめた設定              |
| `bin/`     | `~/.local/bin` へ公開する単独実行 CLI コマンド          |
| `tasks/`   | mise bootstrap で扱わないセットアップや保守用スクリプト |
| `libexec/` | シェルスクリプトから共有するヘルパー                    |
| `deploy/`  | 旧構成から移行するための限定的な処理                    |
| `tests/`   | 一時的なホームディレクトリを使う Go の結合テスト        |
| `docs/`    | リポジトリ全体の設計と運用ポリシー                      |

## 📚 詳細ドキュメント

README は概要に留め、詳しい設計や運用は次のドキュメントに分けています。

- [docs/index.md](docs/index.md): ドキュメントの入口
- [docs/architecture.md](docs/architecture.md): ディレクトリ構成と責務境界
- [docs/bootstrap-design.md](docs/bootstrap-design.md): mise bootstrap の責務と移行規則
- [docs/command-model.md](docs/command-model.md): グローバルコマンド、シェル関数、mise タスクの使い分け
- [docs/abbreviation-policy.md](docs/abbreviation-policy.md): シェル省略コマンドの設計方針
- [docs/ai-tools.md](docs/ai-tools.md): AI ツールと apm の運用方針
- [docs/operations.md](docs/operations.md): 変更内容に応じた確認方法

Neovim 固有の方針は `config/editors/nvim/lua/policies/` に置いています。
