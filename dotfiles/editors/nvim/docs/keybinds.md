# Neovim キーバインド設計

## 関連ポリシー

- [Neovim ドキュメント目次](./README.md)
  - Neovim 固有の設計と運用の目次
- [省略入力の命名ポリシー](../../../../docs/abbreviation.md)
  - シェルの省略コマンドと共有する `verb + object` の文法を定義
- [タブ/バッファ表示ポリシー](./tab-buffer.md)
  - タブとバッファの役割および表示方針を定義
- [todo.txt 運用ガイド](./todotxt.md)
  - todo.txt の書式と Neovim での操作方法を解説

## 基本方針

- 通常キーから始まる追加キーバインドは **動詞 (prefix) + 目的語 (object)** の形式で設計する
  - 動詞 (1 打鍵目) は「操作の種類」を表す
  - 目的語 (2 打鍵目以降) は、各動詞の名前空間に対応する辞書に従う
- `<leader>` から始まるキーバインドは **対象 (object) + 動作 (action)** の形式で設計する
- Vim の標準キーバインドを尊重する
  - 例: `hjkl` / `d` / `c` / `x` / `y` / `p` / `f/F/t/T` / `w/e/b`
  - キーを再定義する場合であっても、削除、貼り付け、挿入、選択、ヤンクといった元の役割を崩さない
  - `Y` は例外として相対パスの参照コピーに割り当て、行単位のヤンクには `yy` を用いる
- プラグイン単位ではなく「操作の意味」に基づいて分類する

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

- 目的語は同じ動詞の中で辞書を統一する
  - 例: b=buffer, d=diagnostic, f=file/format, s=symbol
- 動詞の割り当ては必ず遵守する
  - `g`=ジャンプ、`s`=一覧/検索 UI、`r`=情報表示、`t`=状態反転
  - `m`=書き換え、`X`=実行、`[ ]`=巡回移動、`z`=画面操作
  - `g` はカーソル位置を基準に対象へ移動・参照する操作、`s` はカーソル位置に依存しない検索や一覧 UI を開く操作とする
  - Normal モードのみ `t` を toggle として再定義し、Operator-pending モードの `t/T` は維持する
  - カーソル位置に依存する候補表示や詳細表示は `r`、カーソル位置に依存しない検索・一覧 UI は `s`、即時実行は `X` に寄せる
- 小文字と大文字を使い分ける
  - 小文字=狭い範囲 (ローカル)、大文字=広い範囲 (グローバル)。似た意味を持つ操作は利用頻度の高い方を小文字にする
- `<leader>` は、対象を選択してから動作を選ぶコマンドツリーとして扱う
  - 頻繁に利用し、関連する操作をまとめることで記憶しやすくなる対象に限定して追加する
  - プラグインや外部ツールごとに名前空間を無暗に増やさない
  - `<leader>w` はウィンドウ操作、`<leader>b` はバッファ操作、`<leader>t` は TODO 操作、`<leader>T` はタブ操作に固定する
  - 作成、削除、一覧表示、サイズ変更などの動作は、各対象の後続キーに割り当てる
  - ウィンドウ間の移動は `<C-h/j/k/l>` に固定し、作成や配置変更などの操作は `<leader>w…` に寄せる
- 例外および固定ルール
  - 単独の `s` / `S` および `r` / `R` は通常操作に割り当てず、誤入力防止のため `<Nop>` とする
  - `/` は nvim-hlslens で拡張した Vim 標準の前方検索、`?` は Flash の Tree-sitter 範囲検索に割り当てる
  - `gw` は表示範囲を対象とする Jab のラベル検索、`J` は Hop の単語ジャンプに割り当てる
  - ラベルを直接入力して移動先を選択する UI では、Vim 標準の `n/N` や `;/,` を上書きしない
  - picker や補完のように入力欄を含む候補 UI では、候補内の移動を `<C-n>`=次、`<C-p>`=前に寄せる
  - 前後移動の方向を指定してから対象種別を選ぶ巡回操作は `[ ]` に寄せる
  - LSP hover は頻繁に使うため `K` を維持する
  - `vv` は `dd` や `yy` と同様に行単位の操作として扱い、現在行から count 行を選択する
  - コメントのトグルは VS Code のキーマップに合わせるため `<leader>/` を維持する
  - mini.files は操作性の都合から `-` / `_` を維持する
  - マーク機能は `m` ではなく `M` に移動する (`m` を modify に割り当てるため)

## 目的語キー一覧

| Key | Object                  | 用途                                  |
| --- | ----------------------- | ------------------------------------- |
| `a` | action                  | code action、自動保存などの操作       |
| `b` | buffer                  | バッファ                              |
| `c` | comment / call          | コメント、call hierarchy              |
| `d` | diagnostic              | 診断                                  |
| `e` | explorer                | ファイルツリー                        |
| `f` | file / format           | ファイル、フォーマット                |
| `g` | git                     | Git 関連の一覧や操作                  |
| `h` | help / hidden           | ヘルプ、隠しファイル                  |
| `i` | info / ignored          | hover 情報、ignored file              |
| `j` | jumplist                | jumplist                              |
| `k` | keymap                  | キーマップ                            |
| `l` | line / loclist          | 検索対象の行、location list           |
| `m` | markdown                | Markdown 関連の操作                   |
| `n` | notification            | 通知                                  |
| `p` | picker / pair / preview | picker 一覧、対応する括弧、プレビュー |
| `q` | quickfix                | quickfix                              |
| `r` | register                | レジスタ                              |
| `s` | symbol/status           | シンボル、Git status                  |
| `t` | tab / test / todo       | タブ、テスト、TODO                    |
| `u` | undo                    | undo 履歴                             |
| `w` | word / window           | 単語単位の操作、ウィンドウ            |
| `z` | zoxide                  | zoxide で管理するディレクトリ         |

## 挿入モードの方針

- Insert モードの `<Tab>` / `<S-Tab>` は補完候補の選択移動には使わず、インデントおよびスニペットの展開・ジャンプに優先して割り当てる
- 補完候補の前後移動は `<C-n>` / `<C-p>` を基本とする
- 補完の確定は `<CR>` または明示的な accept キーに寄せ、`<Tab>` による暗黙の確定は避ける
- 理由
  - `<Tab>` はインデント入力とスニペット操作の双方で自然に使える
  - 補完候補の移動を `<Tab>` に載せると、インデント・スニペット・補完選択の責務が衝突しやすい
  - `<C-n>` / `<C-p>` は Vim 標準の補完操作と整合し、将来 Neovim 標準補完へ移行する際も破綻しにくい

## サンプルキーバインド

| Group         | Key          | Reading                 | Action                      |
| ------------- | ------------ | ----------------------- | --------------------------- |
| `g` (go)      | `gd`         | go definition           | 定義へジャンプ              |
| `g` (go)      | `gr`         | go references           | 参照へジャンプ              |
| `g` (go)      | `ge`         | go explorer             | Explorer とエディタ間を移動 |
| `s` (search)  | `sf`         | search file             | ファイル検索                |
| `s` (search)  | `sF`         | search recent           | 最近のファイル検索          |
| `s` (search)  | `sb`         | search buffer           | バッファ検索                |
| `s` (search)  | `sl`         | search lines            | 現在のバッファ内の行を検索  |
| `s` (search)  | `sL`         | search lines workspace  | ワークスペース内の行を検索  |
| `r` (reveal)  | `rd`         | reveal diagnostic float | diagnostic float 表示       |
| `r` (reveal)  | `ra`         | reveal code actions     | code action 一覧表示        |
| `r` (reveal)  | `rq`         | reveal quickfix list    | quickfix を開く             |
| `t` (toggle)  | `ta`         | toggle auto-save        | 自動保存の ON/OFF           |
| `t` (toggle)  | `tt`         | toggle terminal         | ターミナルの ON/OFF         |
| `t` (toggle)  | `tq`         | toggle quickfix         | quickfix の ON/OFF          |
| `t` (toggle)  | `tl`         | toggle location list    | loclist の ON/OFF           |
| `m` (modify)  | `mr`         | modify rename           | rename                      |
| `m` (modify)  | `mf`         | modify format           | format                      |
| `m` (modify)  | `mw`         | modify word             | 直前検索を置換              |
| `m` (modify)  | `mW`         | modify word workspace   | quickfix 対象を置換         |
| `X` (execute) | `Xtn`        | execute test nearest    | 最も近いテストを実行        |
| `X` (execute) | `Xtf`        | execute test file       | 現在のファイルをテスト      |
| `X` (execute) | `Xta`        | execute test all        | 作業ディレクトリをテスト    |
| `X` (execute) | `Xtl`        | execute test last       | 直前のテストを再実行        |
| `X` (execute) | `Xts`        | execute test stop       | 最も近いテストを停止        |
| `r` (reveal)  | `rts`        | reveal test summary     | テストツリーを表示          |
| `r` (reveal)  | `rto`        | reveal test output      | テストの出力を表示          |
| `[`, `]`      | `[d`         | cycle prev diagnostic   | 前の diagnostic             |
| `[`, `]`      | `]d`         | cycle next diagnostic   | 次の diagnostic             |
| `[`, `]`      | `[t`         | cycle prev tab          | 前のタブ                    |
| `[`, `]`      | `]t`         | cycle next tab          | 次のタブ                    |
| `<leader>`    | `<leader>/`  | toggle comment          | コメントの ON/OFF           |
| `<leader>w`   | `<leader>ws` | window split            | 横分割                      |
| `<leader>w`   | `<leader>wv` | window vsplit           | 縦分割                      |
| `<leader>t`   | `<leader>tn` | todo new                | TODO を追加                 |
| `<leader>t`   | `<leader>tt` | todo toggle             | `todo.txt` の表示を切り替え |
| `<leader>t`   | `<leader>td` | todo done               | `done.txt` の表示を切り替え |
| `<leader>t`   | `<leader>tg` | todo ghost text         | ghost text の ON/OFF        |
| `<leader>T`   | `<leader>Tn` | tab new                 | タブを作成                  |
| `<leader>T`   | `<leader>Ts` | tab split               | 現在のバッファをタブへ分割  |
| `<leader>T`   | `<leader>Tq` | tab quit                | タブを閉じる                |
| `z`           | `zz`         | built-in center screen  | 画面中央へ                  |
| `z`           | `zt`         | built-in top of screen  | 画面上へ移動                |
