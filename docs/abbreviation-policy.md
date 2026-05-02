# shell の省略コマンド名ポリシー

## 目的

省略コマンド名は単なる短縮ではなく、意味のある辞書として設計する。場当たり的な語呂合わせを増やさず、少数の規則で思い出せる体系を維持する。

## 基本原則

- `verb + object` を基本形にする
- 必要なら短い qualifier を1つ足す
- 実装詳細ではなく意味で命名する
- 使用頻度が十分に高いものだけを省略コマンド名にする

## 語彙の考え方

ここでの `verb` は動作、`object` は対象、`qualifier` は補足の意味です。

### verb

- `r`: reveal / open
- `a`: add / create / append
- `d`: delete / remove
- `s`: search / select

### object

- `w`: worktree
- `r`: repository
- `b`: branch
- `t`: task

### qualifier

- `c`: VS Code
- `f`: Fork
- `l`: lazygit
- `n`: Neovim
- `z`: zoxide

## 良い省略コマンド名

- 同じ verb は同じ意味を保つ
- 同じ object は同じ対象を保つ
- 展開先は `mise run ...` ではなく実コマンドにする

例:

- `rr` -> `reveal-repository`
- `rrn` -> `reveal-repository-with-neovim`
- `rrc` -> `reveal-repository-with-code`
- `rrf` -> `reveal-repository-with-fork`
- `rrl` -> `reveal-repository-with-lazygit`
- `rrz` -> `reveal-repository-with-zoxide`
- `aw` -> `add-worktree`
- `dw` -> `delete-worktree`
- `sb` -> `search-bookmarks`
- `st` -> `search-task`

## 避けるもの

- `mise run ...` という実装詳細を名前に含めること
- 一回限りの語呂合わせ
- 同じ接頭辞に複数の意味を持たせること

## Neovim キーバインドとの関係

この方針は `nvim/lua/policies/keybinds-policy.md` と同じ発想です。どちらも「意味ベースの辞書で覚えられること」を優先します。

ただし対象は異なります。

- Neovim のポリシー
  - editor 内の操作体系
- shell の省略コマンド名ポリシー
  - shell 上のコマンド起動体系
