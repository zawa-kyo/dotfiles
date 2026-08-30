# Neovim 設定の構成

## Lua モジュール

`lua/` 配下は、次の責務で分ける。

- `config/`: Neovim 本体の起動時設定と複数機能で使う基盤
- `plugins/`: plugin spec と、そのプラグイン機能に固有のモジュール
- `snippets/`: ファイル形式ごとのスニペット

`plugins/` の第一階層は、プラグイン名ではなく機能で分類する。
複数の機能から参照するファイル探索の状態は `plugins/files/` のような中立的な場所に置く。

## plugin spec の読み込み

lazy.nvim は `plugins/` 直下の Lua ファイルと、`init.lua` を持つ直下のディレクトリをplugin specとして読み込む。
このため、`plugins/` 直下の`init.lua`はplugin specまたはそのリストを返し、副作用を持たせない。

plugin spec以外の内部モジュールは、`plugins/files/`や`plugins/navigation/mini-files/`のように1階層深いディレクトリへ置く。
内部モジュールだけを収めるディレクトリには`init.lua`を作らない。

同じプラグインを複数の機能から設定する場合は、各機能のplugin specにその機能の`opts`とキーバインドを置く。
プラグイン全体に関わる初期化だけを、`plugins/`直下のplugin specが担当する。

## Picker の操作層

Pickerを開く処理は`plugins/picker/actions.lua`にまとめる。
`keymaps.lua`はキー、action、説明の対応だけを宣言し、Snacksや検索オプションを直接組み立てない。

ダッシュボードなどキーマップ以外の入口も同じactionを呼び出し、検索方法とオプションを共有する。
