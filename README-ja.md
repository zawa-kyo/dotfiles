# 🏠 dotfiles

エディタ、ターミナル、CLI、ローカルツールチェーンの設定をまとめて管理する dotfiles リポジトリです。

この README は、初回セットアップと普段使う入口だけを扱います。
設計や運用の詳細は `docs/`、エージェント向けの案内は `AGENTS.md` を確認してください。

## ✨ 管理対象

- Neovim と VS Code のエディタ設定
- Zsh、Starship、Ghostty、WezTerm、Zellij などのターミナル周辺設定
- Homebrew、Bun、mise、procs などのローカルツール設定
- `scripts/global/` で公開する作業用 CLI コマンド
- Codex や Claude Code などで使う AI ツール設定
- エディタと LSP の動作確認に使うサンプルファイル

## 🚀 クイックスタート

リポジトリを clone して作業ディレクトリへ移動します。

```sh
git clone [repository_url]
cd [cloned_repository_path]
```

シェルで `mise` が使えない場合は先にインストールします。

```sh
brew install mise
```

セットアップは次のタスクに集約しています。

```sh
mise run install
```

このタスクでは、次の作業をまとめて行います。

- dotfiles 管理ファイルのリンク
- ユーティリティコマンドの同期
- mise 管理ツールのインストール
- apm 管理スキルの反映
- Bun グローバル環境の準備
- pre-commit hook のインストール

## 🛠️ よく使うコマンド

| コマンド                    | 用途                                                      |
| --------------------------- | --------------------------------------------------------- |
| `mise run install`          | 標準のローカルセットアップを実行する                      |
| `mise run relink`           | 実ファイルを上書きせず、dotfiles 管理のリンクだけ張り直す |
| `mise run format`           | Git の追跡対象ファイルを整形する                          |
| `mise run check-pre-commit` | リポジトリ全体の pre-commit チェックを実行する            |
| `mise run upgrade`          | mise、apm、Neovim、Bun、Homebrew の依存関係を更新する     |
| `mise tasks`                | 利用できる mise タスクを一覧する                          |

`scripts/global/` のコマンドはグローバルにリンクします。
Git 操作やタスク検索など、日常作業で直接使う小さな CLI ツールをここに置いています。

## 🗂️ リポジトリ構成

| パス                    | 役割                                             |
| ----------------------- | ------------------------------------------------ |
| `config/editors/`       | Neovim、VS Code、確認用サンプルの設定            |
| `config/shell/`         | Zsh、Sheldon、Starship などのシェル設定          |
| `config/terminal-apps/` | Ghostty、WezTerm、Zellij などの端末アプリ設定    |
| `config/tools/`         | Homebrew、Bun、Git、mise、procs などのツール設定 |
| `config/ai/`            | AI ツール向けの指示と apm 管理設定               |
| `scripts/local/`        | セットアップや保守用のローカルスクリプト         |
| `scripts/global/`       | グローバルに公開する単独実行 CLI コマンド        |
| `scripts/utils/`        | シェルスクリプトから共有するヘルパー             |
| `docs/`                 | リポジトリ全体の設計と運用ポリシー               |

## 📚 詳細ドキュメント

README は概要に留め、詳しい設計や運用は次のドキュメントに分けています。

- [docs/index.md](docs/index.md): ドキュメントの入口
- [docs/architecture.md](docs/architecture.md): ディレクトリ構成と責務境界
- [docs/command-model.md](docs/command-model.md): グローバルコマンド、シェル関数、mise タスクの使い分け
- [docs/abbreviation-policy.md](docs/abbreviation-policy.md): シェル省略コマンドの設計方針
- [docs/ai-tools.md](docs/ai-tools.md): AI ツールと apm の運用方針
- [docs/operations.md](docs/operations.md): 変更内容に応じた確認方法

Neovim 固有の方針は `config/editors/nvim/lua/policies/` に置いています。
