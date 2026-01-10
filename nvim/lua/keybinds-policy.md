# Neovim Keybinding Design Policy

## 基本方針

- 追加キーバインドは **動詞 (prefix) + 目的語 (object)** の形式で設計する
  - 動詞（1 打鍵目）は「操作の種類」を表す
  - 目的語（2 打鍵目以降）は固定された“辞書”に従う
- Vim 標準操作（`hjkl`, `d`, `c`, `x`, `y`, `p`, `f/F/t/T`, `w/e/b` など）は尊重する
- プラグイン単位ではなく「操作の意味」で分類する

## 動詞キーの定義

| Key     | Verb       | Meaning                                |
| ------- | ---------- | -------------------------------------- |
| `g`     | go         | カーソルジャンプ・意味的移動           |
| `s`     | search     | 検索・一覧 UI を開く                   |
| `S`     | show       | 表示・peek・hover 等の"覗く"操作       |
| `t`     | toggle     | 状態の反転・表示/非表示                |
| `m`     | modify     | コードを書き換える操作                 |
| `r`     | run        | 実行する操作                           |
| `X`     | execute    | 強制実行・即実行・危険度の高い実行     |
| `[ , ]` | cycle      | 意味的な前後関係を巡回                 |
| `z`     | (built-in) | 画面・表示範囲の移動（Vim 標準のまま） |

## 各動詞の役割

| Key     | Role       | Examples                                                                               |
| ------- | ---------- | -------------------------------------------------------------------------------------- |
| `g`     | go         | 定義、宣言、実装、型、参照、診断位置などへのジャンプ                                   |
| `s`     | search     | ファイル、バッファ、シンボル、診断、参照などの一覧 UI を開く                           |
| `S`     | show       | hover、signature、peek definition、peek references、diagnostic float など              |
| `t`     | toggle     | number, relativenumber, wrap, spell, diagnostics, indent guide, terminal などの ON/OFF |
| `m`     | modify     | rename, format, organize imports, quick fix, code action 適用など                      |
| `r`     | run        | test 実行、codelens 実行、LSP コマンド、ツール実行など                                 |
| `X`     | execute    | 強制実行、即時適用、リスクのある操作 (LSP 再起動、即適用系など)                        |
| `[ , ]` | cycle      | diagnostics, quickfix, buffer, hunk, todo などを前後に巡回                             |
| `z`     | (built-in) | 画面位置・表示範囲の移動、折りたたみ、スクロールなど (Vim 標準機能)                    |

## 運用ルール

- 同じ目的語は原則的に同じキーを使う
  - 例：b=buffer, d=diagnostic, f=file/format, s=symbol
- ジャンプは必ず `g`
- 一覧・検索 UI は必ず `s`
- 表示だけなら `S`
- 状態の反転は `t`
  - Normal モードのみ `t` を toggle として再定義し、Operator-pending の `t/T` は維持する
- コードが変わるなら `m`
  - 一度一覧を開いてから選択、実行するものは `S`、即座に実行するものは `m` に寄せる
- 何かを動かすなら `r`, `X`
- 同種を順に回るなら `[`, `]`
- 画面操作は `z` に限定する
- 小文字/大文字の使い分け
  - 同じ目的語で `sf`/`sF` のように大小を使う場合は、小文字=狭い範囲、大文字=広い範囲
  - `st`/`sT` のように意味が近い場合は、使用頻度が高い方を小文字に割り当てる
- `<leader>` の扱い
  - `<leader>` は特別扱いで、その他のルールと整合しない機能を実行する場合などに使う
- 例外
  - LSP hover は頻繁に使うため `K` を維持する

## サンプルキーバインド

| Group         | Key  | Verb                   | Action                |
| ------------- | ---- | ---------------------- | --------------------- |
| `g` (go)      | `gd` | go definition          | 定義へジャンプ        |
| `g` (go)      | `gr` | go references          | 参照へジャンプ        |
| `s` (search)  | `sf` | search file            | ファイル検索          |
| `s` (search)  | `sb` | search buffer          | バッファ検索          |
| `S` (show)    | `Sh` | show hover             | hover 表示            |
| `S` (show)    | `Sd` | show diagnostic float  | diagnostic float 表示 |
| `t` (toggle)  | `tn` | toggle number          | 行番号の ON/OFF       |
| `t` (toggle)  | `tw` | toggle wrap            | wrap の ON/OFF        |
| `m` (modify)  | `mr` | modify rename          | rename                |
| `m` (modify)  | `mf` | modify format          | format                |
| `r` (run)     | `rt` | run test               | テスト実行            |
| `r` (run)     | `rl` | run codelens           | codelens 実行         |
| `X` (execute) | `Xr` | execute restart lsp    | LSP 再起動            |
| `X` (execute) | `Xf` | execute force format   | format を強制実行     |
| `[`, `]`      | `[d` | cycle prev diagnostic  | 前の diagnostic       |
| `[`, `]`      | `]d` | cycle next diagnostic  | 次の diagnostic       |
| `z`           | `zz` | built-in center screen | 画面中央へ            |
| `z`           | `zt` | built-in top of screen | 画面上へ移動          |
