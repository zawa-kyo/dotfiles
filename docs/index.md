# ドキュメント目次

この `docs/` ディレクトリは、リポジトリ全体に関わる設計判断と運用方針をまとめる場所です。

## 全体設計

- [architecture.md](architecture.md)
  - リポジトリ全体の構造と責務分担
- [ai-skills.md](ai-skills.md)
  - AI スキルを管理するための運用方針

## コマンドとタスクの設計

- [command-model.md](command-model.md)
  - 単独実行コマンド / シェル関数 / `mise run` の役割分担
- [abbreviation-policy.md](abbreviation-policy.md)
  - シェルの省略コマンド名の命名原則

## 運用と確認

- [operations.md](operations.md)
  - 変更後の確認方針

## サブシステム固有ポリシー

- [../nvim/lua/policies/keybinds-policy.md](../nvim/lua/policies/keybinds-policy.md)
  - Neovim キーバインド設計
- [../nvim/lua/policies/tab-buffer-policy.md](../nvim/lua/policies/tab-buffer-policy.md)
  - Neovim タブ/バッファ表示方針

## 配置ルール

- 人向けの入口は `README.md`
- エージェント向けの入口は `AGENTS.md`
- リポジトリ全体の長い設計判断は `docs/`
- サブシステム固有の詳細規約は実装の近くに置く
