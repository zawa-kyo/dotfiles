# ドキュメント目次

リポジトリ全体に関わる設計方針や運用ポリシーをまとめたドキュメントの目次です。

## 全体設計

- [architecture.md](./architecture.md)
  - リポジトリ全体の構造とファイルの配置方針
- [bootstrap-design.md](./bootstrap-design.md)
  - `mise bootstrap` の役割、競合発生時の動作、移行処理とテストの設計
- [ai-tools.md](./ai-tools.md)
  - AI ツールおよびスキルの管理・運用方針

## コマンドとタスクの設計

- [command-model.md](./command-model.md)
  - 単独実行コマンド / シェル関数 / `mise run` の役割分担
- [abbreviation.md](./abbreviation.md)
  - シェルの省略コマンドと Neovim キーバインドに共通する命名規則

## 運用と確認

- [operations.md](./operations.md)
  - 変更内容に応じた動作確認と検証の手順

## ツール別ドキュメント

- [Neovim](../dotfiles/editors/nvim/docs/README.md)
  - Neovim 固有の設計・設定および運用ドキュメントの目次
- [シェル環境（Zsh）](../dotfiles/shell/docs/README.md)
  - Zsh の起動順序、プラグイン管理、高速化方針
- [Karabiner-Elements](../dotfiles/tools/karabiner/docs/README.md)
  - macOS のキーリマップおよび打鍵効率化の設計方針
