# シェルの省略コマンド名ポリシー

## 目的

省略コマンド名では、同じ文字を同じ意味で使います。場当たり的な語呂合わせを増やさず、少数の規則で覚えられるようにします。

## 基本原則

- `verb + object` を基本形にする
- 必要なら短い qualifier を1つ足す
- 実装詳細ではなく意味で命名する
- 使用頻度が十分に高いものだけを省略コマンド名にする

## 語彙の考え方

ここでの `verb` は動作、`object` は対象、`qualifier` は補足の意味です。

### verb

- `c`: checkout / change
- `r`: reveal / open
- `a`: add / create / append
- `d`: delete / remove
- `s`: search / select
- `g`: go / move or open the current context

### object

- `w`: worktree
- `r`: repository
- `b`: branch
- `t`: task

### qualifier

- `b`: browser
- `c`: VS Code
- `f`: Fork
- `l`: lazygit
- `n`: Neovim
- `z`: zoxide

## 良い省略コマンド名

- 同じ verb は同じ意味を保つ
- 同じ object は同じ対象を保つ
- 展開先は `mise run ...` ではなく実コマンドにする

例を示す。

- `rr` -> `reveal-repository-with-zoxide`
- `rrb` -> `reveal-repository-with-browser`
- `rrn` -> `reveal-repository-with-neovim`
- `rrc` -> `reveal-repository-with-code`
- `rrf` -> `reveal-repository-with-fork`
- `rrl` -> `reveal-repository-with-lazygit`
- `rrz` -> `reveal-repository-with-zoxide`
- `gd` -> `z $HOME/Desktop`
- `gdl` -> `z $HOME/Downloads`
- `gh` -> `z $HOME`
- `gl` -> `z $DIR_LOCAL_CONFIG`
- `gr` -> `z $(git rev-parse --show-toplevel)`
- `grb` -> `gh browse`
- `aw` -> `wt switch --branches`
- `awr` -> `wt switch --remotes`
- `cb` -> `switch-branch`
- `cbr` -> `switch-branch-remote`
- `dw` -> `wt remove`
- `sb` -> `search-bookmarks`
- `st` -> `search-task`
- `sT` -> `search-theme`

## 避けるもの

- `mise run ...` という実装詳細を名前に含めること
- 1 回限りの語呂合わせ
- 同じ接頭辞に複数の意味を持たせること

## Neovim キーバインドとの関係

この方針は `dotfiles/editors/nvim/lua/policies/keybinds-policy.md` と同じく、同じキーに一貫した意味を持たせます。

ただし対象は異なります。

- Neovim のポリシー
  - エディタ内の操作
- シェルの省略コマンド名ポリシー
  - シェルからのコマンド呼び出し
