# 🏠 dotfiles

エディタ、ターミナル、CLI、ローカルツールチェーンの設定を管理する個人用 dotfiles リポジトリです。

## ✨ 概要

このリポジトリには次の設定が含まれます。

- `nvim/` の Neovim 設定
- `terminal/`, `ghostty/`, `wezterm/`, `zellij/`, `starship/` のターミナルとシェル設定
- `vscode/` の VS Code 設定
- `homebrew/Brewfile` の Homebrew パッケージ定義
- `bun/` の Bun グローバルパッケージ定義
- `procs/` の procs 設定
- `scripts/` のローカルセットアップ処理と公開 CLI コマンド
- `ai/` の AI ツール設定

この README ではセットアップと日常利用の手順を扱います。リポジトリ設計は `docs/`、エージェント向けの案内は `AGENTS.md` を参照してください。

## 🚀 クイックスタート

リポジトリを clone して作業ディレクトリに移動します。

```sh
git clone [repository_url]
cd [cloned_repository_path]
```

シェルで `mise` が使えない場合は、先にインストールします。

```sh
brew install mise
```

インストーラを実行します。

```sh
mise run install
```

`mise run install` は dotfiles 管理ファイルのリンク、公開グローバルコマンドの同期、ローカル `mise` ツールのインストール、Bun グローバル環境の準備、リポジトリの pre-commit hook のインストールを行います。

## 🛠️ 日常的に使用するコマンド

Mise タスク:

```sh
mise run install
mise run relink
mise run install-pre-commit
mise run check-pre-commit
mise run format
mise run upgrade
```

グローバルコマンド:

```sh
add-worktree
add-worktree-remote
delete-worktree
reveal-repository-with-neovim
search-abbreviation
search-task
switch-branch
switch-branch-remote
```

## 🗂️ リポジトリ構成

- `nvim/`: Neovim 設定とプラグイン定義
- `vscode/`: VS Code の settings と keybindings
- `scripts/local/`: セットアップとリポジトリローカルのスクリプト
- `scripts/global/`: 単独実行できる公開 CLI コマンド
- `scripts/utils/`: シェル用の共通ヘルパー
- `homebrew/`: 管理対象の `Brewfile`
- `bun/`: リポジトリ内で管理する Bun グローバルパッケージ
- `procs/`: プロセスビューア設定
- `sheldon/`: シェルプラグインマネージャ設定と省略コマンド
- `ai/`: AI ツール設定
- `src/samples/`: エディタと LSP 確認用のサンプルファイル

## 🧩 サブシステム

### 🪝 Pre-commit

Python 開発依存は `uv` で管理します。

```sh
uv sync --group dev
uv run pre-commit install
```

すべてのチェックを実行します。

```sh
uv run pre-commit run -a
```

### 🌿 Git

このリポジトリは基本の `$HOME/.gitconfig` をリンクします。

- `scripts/local/link-dotfiles.sh` を実行して `git/.gitconfig` をリンクする
- マシン固有の上書きは `$HOME/.gitconfig.local` に置く
- `ghq get` で取得するリポジトリは `$GHQ_ROOT` 配下に置く
- `mise/conf.d/env.toml` は `$GHQ_ROOT` を既定で `$HOME/Git/ghq` に設定する

`terminal/.zshrc` がリンクされている場合、`add-worktree`, `add-worktree-remote`, `switch-branch`, `switch-branch-remote`, `delete-worktree` で `fzf` を使った branch / worktree 操作ができます。

### 🚀 Starship

Starship は `$STARSHIP_CONFIG` を使い、シェル起動時の既定値は `$STARSHIP_DEFAULT_THEME` から設定されます。

カスタムテーマは `starship/themes/*.toml` に置きます。`search-theme` または `sT` 省略コマンドを実行すると、現在のシェルセッションだけテーマを切り替えられます。新しいターミナルを開くと既定テーマに戻ります。

### 🧑‍💻 VS Code

macOS では、`scripts/local/link-dotfiles.sh` が VS Code のユーザーファイルも VS Code のユーザー設定ディレクトリへリンクします。

`settings.json` や `keybindings.json` がすでに実ファイルとして存在する場合、スクリプトは上書きせずに警告を出してスキップします。

### 🤖 AI Tools

`ai/` ディレクトリには AI ツール設定を置きます。

- 再利用可能なスキルは `apm/apm.yml` の依存関係として管理する
- `mise run install` は `apm install -g` を実行し、lock ファイルに固定されたスキルを適用する
- `mise run upgrade` は apm 管理のスキルと `apm/apm.lock.yaml` を更新する
- `mise/conf.d/env.toml` は標準パスを定義する
- カスタムスキルは、英語のコミットメッセージなど成果物に明示的な言語要件がある場合を除き、ユーザーの依頼言語で応答する

### 🥟 Bun

Bun グローバル環境を準備します。

```sh
mise run install-bun
```

このコマンドは管理対象の Bun グローバルディレクトリをリンクし、`bun/package.json` の依存関係をインストールします。

### 🍺 Homebrew

管理対象の Homebrew パッケージをインストールします。

```sh
brew bundle --file=homebrew/Brewfile
```

現在のマシン状態から管理対象の `Brewfile` を更新します。

```sh
brew bundle dump --file=homebrew/Brewfile --force
```

### 🏃 Task Runner

`mise` はタスク実行と一覧確認の入口として使います。

- `mise run install` は標準のローカルセットアップを実行する
- `mise run format` は Git の追跡対象ファイルを整形する
- `mise run check-pre-commit` はリポジトリ全体のチェックを実行する
- `scripts/global/` の公開コマンドは、生成された `mise` タスクラッパー経由でも実行できる

## 📚 設計ドキュメント

リポジトリ全体の設計とポリシー:

- [docs/index.md](docs/index.md)
- [docs/architecture.md](docs/architecture.md)
- [docs/command-model.md](docs/command-model.md)
- [docs/abbreviation-policy.md](docs/abbreviation-policy.md)
- [docs/ai-tools.md](docs/ai-tools.md)
- [docs/operations.md](docs/operations.md)

サブシステム固有のポリシー:

- [nvim/lua/policies/keybinds-policy.md](nvim/lua/policies/keybinds-policy.md)
- [nvim/lua/policies/tab-buffer-policy.md](nvim/lua/policies/tab-buffer-policy.md)
