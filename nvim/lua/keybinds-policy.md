# Neovim Keybinding Design Policy

## 基本方針

- 追加キーバインドは **動詞 (prefix) + 目的語 (object)** の形式で設計する
  - 動詞（1 打鍵目）は「操作の種類」
  - 目的語（2 打鍵目以降）は固定された“辞書”に従う
- Vim 標準操作（`hjkl`, `d`, `c`, `x`, `y`, `p`, `f/F/t/T`, `w/e/b` など）は尊重する
- プラグイン単位ではなく「操作の意味」で分類する

## 動詞キー一覧

| Key     | Verb       | 意味/用途                                                               |
| ------- | ---------- | ----------------------------------------------------------------------- |
| `g`     | go         | 定義・宣言・実装・型・参照・診断位置などへのジャンプ                    |
| `s`     | search     | ファイル/バッファ/シンボル/診断/参照などの一覧 UI を開く                |
| `t`     | toggle     | number/wrap/spell/diagnostics/indent guide/terminal の ON/OFF           |
| `m`     | modify     | rename/format/organize imports/quick fix/code action 適用などの書き換え |
| `r`     | reveal     | hover/peek/diagnostic float/通知・履歴などの表示                        |
| `X`     | execute    | test 実行/codelens 実行/LSP コマンド/ツール実行など                     |
| `[ , ]` | cycle      | diagnostics/quickfix/buffer/hunk/todo などの前後移動                    |
| `z`     | (built-in) | 画面位置・表示範囲の移動、折りたたみ、スクロールなど (Vim 標準機能)     |

## 運用ルール

- 目的語は固定の辞書で統一する
  - 例：b=buffer, d=diagnostic, f=file/format, s=symbol
- 動詞の割当は必ず守る
  - `g`=ジャンプ, `s`=一覧/検索 UI, `r`=表示/覗き, `t`=状態反転, `m`=書き換え, `X`=実行, `[ ]`=巡回, `z`=画面操作
- `g` はカーソル位置を基準に移動/参照する操作、`s` はカーソル位置に依存しない検索/一覧を開く操作とする
- Normal モードのみ `t` を toggle として再定義し、Operator-pending の `t/T` は維持する
- 実行の粒度で使い分ける
  - 一覧を見てから選択するものは `r`、即時実行は `X` に寄せる
- 小文字/大文字は使い分ける
  - 小文字=狭い範囲、大文字=広い範囲。近い意味は使用頻度の高い方を小文字にする
- `<leader>` は例外枠として扱い、既存ルールと整合しない機能に使う
  - window/tab/buffer など Vim コアの操作は `<leader>` に集約する
- `S` は使わず、誤入力防止のため `<Nop>` にする
- 例外: LSP hover は頻繁に使うため `K` を維持する
- 例外: コメントのトグルは VSCode のキーマップに寄せるため `<leader>/` を維持する
- 例外: mini.files は操作性の都合で `-` / `_` を維持する
- 例外: mark は `m` を使わず `M` に移動する (modify を `m` に割り当てるため)

## サンプルキーバインド

| Group        | Key         | Verb                    | Action                |
| ------------ | ----------- | ----------------------- | --------------------- |
| `g` (go)     | `gd`        | go definition           | 定義へジャンプ        |
| `g` (go)     | `gr`        | go references           | 参照へジャンプ        |
| `s` (search) | `sf`        | search file             | ファイル検索          |
| `s` (search) | `sF`        | search recent           | 最近のファイル検索    |
| `s` (search) | `sb`        | search buffer           | バッファ検索          |
| `r` (reveal) | `rd`        | reveal diagnostic float | diagnostic float 表示 |
| `r` (reveal) | `ra`        | reveal code actions     | code action 一覧表示  |
| `r` (reveal) | `rq`        | reveal quickfix list    | quickfix を開く       |
| `t` (toggle) | `ta`        | toggle auto-save        | 自動保存の ON/OFF     |
| `t` (toggle) | `tt`        | toggle terminal         | ターミナルの ON/OFF   |
| `t` (toggle) | `tq`        | toggle quickfix         | quickfix の ON/OFF    |
| `t` (toggle) | `tl`        | toggle location list    | loclist の ON/OFF     |
| `m` (modify) | `mr`        | modify rename           | rename                |
| `m` (modify) | `mf`        | modify format           | format                |
| `[`, `]`     | `[d`        | cycle prev diagnostic   | 前の diagnostic       |
| `[`, `]`     | `]d`        | cycle next diagnostic   | 次の diagnostic       |
| `<leader>`   | `<leader>/` | toggle comment          | コメントの ON/OFF     |
| `z`          | `zz`        | built-in center screen  | 画面中央へ            |
| `z`          | `zt`        | built-in top of screen  | 画面上へ移動          |
