# Neovim Keybinding Design Policy

## 基本方針

- 追加キーバインドは **動詞 (prefix) + 目的語 (object)** の形式で設計する
  - 動詞（1 打鍵目）は「操作の種類」
  - 目的語（2 打鍵目以降）は固定された“辞書”に従う
- Vim 標準操作（`hjkl`, `d`, `c`, `x`, `y`, `p`, `f/F/t/T`, `w/e/b` など）は尊重する
- プラグイン単位ではなく「操作の意味」で分類する

## 動詞キー一覧

| Key     | Verb       | 意味/用途                                                                    |
| ------- | ---------- | ---------------------------------------------------------------------------- |
| `g`     | go         | 定義・宣言・実装・型・参照・診断位置などへのジャンプ                         |
| `s`     | search     | ファイル/バッファ/シンボル/診断/参照などの一覧 UI を開く                     |
| `S`     | show       | hover/signature/peek/diagnostic float などの表示・覗き                       |
| `t`     | toggle     | number/relativenumber/wrap/spell/diagnostics/indent guide/terminal の ON/OFF |
| `m`     | modify     | rename/format/organize imports/quick fix/code action 適用などの書き換え      |
| `r`     | run        | test 実行/codelens 実行/LSP コマンド/ツール実行など                          |
| `X`     | execute    | 強制実行・即実行・リスクのある操作 (LSP 再起動、即適用系など)                |
| `[ , ]` | cycle      | diagnostics/quickfix/buffer/hunk/todo などの前後移動                         |
| `z`     | (built-in) | 画面位置・表示範囲の移動、折りたたみ、スクロールなど (Vim 標準機能)          |

## 運用ルール

- 目的語は固定の辞書で統一する
  - 例：b=buffer, d=diagnostic, f=file/format, s=symbol
- 動詞の割当は必ず守る
  - `g`=ジャンプ, `s`=一覧/検索 UI, `S`=表示, `t`=状態反転, `m`=書き換え, `r`/`X`=実行, `[ ]`=巡回, `z`=画面操作
- Normal モードのみ `t` を toggle として再定義し、Operator-pending の `t/T` は維持する
- 実行の粒度で使い分ける
  - 一覧から選択して実行するものは `S`、即時実行は `m` に寄せる
- 小文字/大文字は使い分ける
  - 小文字=狭い範囲、大文字=広い範囲。近い意味は使用頻度の高い方を小文字にする
- `<leader>` は例外枠として扱い、既存ルールと整合しない機能に使う
- 例外: LSP hover は頻繁に使うため `K` を維持する

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
