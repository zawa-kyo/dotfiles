# 運用と確認

## 目的

変更対象に応じて、過不足の少ない確認を選べるようにする。

## 基本方針

- 小さな変更では最小限の確認を行う
- 影響範囲が広い変更では formatter とリポジトリ全体の確認を使う
- ドキュメントだけの変更では重い確認は不要

## 変更種別ごとの確認

### ドキュメントのみ

- 必要に応じて `mise run format`

### Neovim 設定

- 必要に応じて `mise run format`
- プラグインや editor 挙動に関わる場合は `nvim` で `:checkhealth`

### shell script / task / terminal 設定

- 必要に応じて `mise run format`
- 影響範囲が広い場合は `uv run pre-commit run -a`

### Bun

- `mise run install-bun`
- `bunx --version`

### Homebrew

- `brew bundle check --file=homebrew/Brewfile`

## formatter

通常は次を使う。

```sh
mise run format
```

この task は Lua, shell, JSON / JSONC / Markdown / YAML, TOML をまとめて整形する。

## リポジトリ全体の確認

広い変更やリリース前確認では次を使う。

```sh
uv run pre-commit run -a
```

## ドキュメント更新の判断

- 手順が変わる
  - `README.md`
- リポジトリ全体の原則が変わる
  - `docs/`
- サブシステム固有の詳細規約が変わる
  - そのディレクトリ直下の policy
- エージェントの参照導線が変わる
  - `AGENTS.md`
