# ドキュメント目次

この `docs/` ディレクトリは、リポジトリ全体に関わる設計判断と運用方針をまとめる場所です。

## 全体設計

- [architecture.md](architecture.md)
  - リポジトリ全体の構造とファイルの置き場所
- [bootstrap-design.md](bootstrap-design.md)
  - mise bootstrap の役割、競合時の動作、移行とテストの設計
- [ai-tools.md](ai-tools.md)
  - AI ツールを管理するための運用方針

## コマンドとタスクの設計

- [command-model.md](command-model.md)
  - 単独実行コマンド / シェル関数 / `mise run` の役割分担
- [abbreviation-policy.md](abbreviation-policy.md)
  - シェルの省略コマンドと Neovim キーバインドに共通する命名原則

## 運用と確認

- [operations.md](operations.md)
  - 変更後の確認方針

## 各ツールのポリシー

- [../dotfiles/editors/nvim/lua/policies/keybinds-policy.md](../dotfiles/editors/nvim/lua/policies/keybinds-policy.md)
  - Neovim キーバインド設計
- [../dotfiles/editors/nvim/lua/policies/tab-buffer-policy.md](../dotfiles/editors/nvim/lua/policies/tab-buffer-policy.md)
  - Neovim タブ/バッファ表示方針
