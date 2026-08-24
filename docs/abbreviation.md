# 省略入力の命名ポリシー

## 目的

シェルの省略コマンドと Neovim の追加キーバインドに共通する命名規則を定めます。異なる環境でも、操作の種類と対象を同じ順序で読めることを目指します。

各環境に固有の制約やキー一覧は、実装に近いポリシーで定めます。

- [Neovim キーバインド設計](../dotfiles/editors/nvim/lua/policies/keybinds-policy.md)
- [Neovim のタブとバッファの表示方針](../dotfiles/editors/nvim/lua/policies/tab-buffer-policy.md)

## 共通文法

- `verb + object` を基本形にする
- 必要な場合だけ短い qualifier を加える
- 実装するツールやプラグインではなく、利用者の操作で命名する
- 使用頻度が高い操作に短い入力を割り当てる
- 各環境の標準操作と衝突する場合は、その標準操作を優先する

`verb` は操作の種類を表し、後続キーの名前空間になります。`object` と `qualifier` の意味は、文字単独ではなく先行する `verb` と組み合わせて解釈します。同じ環境の同じ名前空間では、同じ文字に一貫した意味を持たせます。

たとえば、`sl` は `s`（search）と `l`（line）からなる「行を検索する操作」です。一方、`rl` や `tl` の `l` は Neovim の location list を表せます。異なる操作まで含めて一文字の意味を固定すると、Vim 標準操作や既存の自然な組み合わせと衝突するためです。

## 共通する動詞

- `g`: go。現在の文脈から対象へ移動する
- `s`: search。現在の文脈に依存しない検索または一覧を開く
- `r`: reveal。対象や現在の文脈に関する情報を表示する

同じ操作をシェルと Neovim の両方で表現できる場合は、Neovim のキーバインド設計を基準に文字を選びます。ただし、各環境で一般的な操作や標準キーを崩してまで表記を揃えません。

小文字と大文字の組み合わせを持つ場合は、小文字を狭い範囲、大文字を広い範囲に割り当てます。たとえば、Neovim の `sl` は現在のバッファ、`sL` はワークスペースを検索します。大文字側に対応する自然な操作がない環境では、対になる入力を無理に追加しません。

## シェルの省略コマンド

シェルでは、共通する動詞に加えて次の動詞を使います。

- `a`: add / create / append
- `c`: checkout / change
- `d`: delete / remove

対象と修飾子は、同じ動詞から始まる省略コマンドの中で意味を揃えます。

- `rr`: reveal repository
- `rrb`: reveal repository with browser
- `rrn`: reveal repository with Neovim
- `aw`: add worktree
- `awr`: add worktree from remote branch
- `cb`: change branch
- `cbr`: change to remote branch
- `sf`: search files
- `sfa`: search all files
- `sfs`: search files case-sensitively
- `sl`: search lines
- `sln`: search lines with Neovim
- `sls`: search lines case-sensitively

省略コマンドの展開先には、`mise run ...` のような実行経路ではなく、利用者が呼び出す実コマンドを指定します。

## 例外

`ls`、`vim`、`grep` など、既存コマンドとの互換性を目的とする省略はこの文法の対象外です。既存の入力を置き換えるものと、独自の操作名として設計するものを区別します。

新しい省略入力を追加するときは、次を確認します。

- 同じ動詞の名前空間に既存の意味があるか
- 既存の短い入力と衝突しないか
- 使用頻度が短縮に見合うか
- 実装名を変更しても操作名を維持できるか
