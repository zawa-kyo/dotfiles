# Neovim 設定の構成

## 関連ドキュメント

- [Neovim ドキュメント目次](./README.md)
  - Neovim 固有の設計と運用の目次

## Lua モジュール

`lua/` 配下は、次の責務に基づいてディレクトリを分割します。

- `config/`: Neovim 本体の起動時設定および複数機能から参照される共通基盤
- `plugins/`: plugin spec 定義および各プラグイン機能に固有のモジュール
- `snippets/`: ファイル形式別のスニペット定義

`plugins/` の第 1 階層は、プラグイン名ではなく機能カテゴリ (`coding/`、`editing/`、`files/`、`lsp/` など) で分類します。複数の機能から参照されるファイル探索の状態などは、`plugins/files/` のような中立的な場所に配置します。

## plugin spec の読み込み

lazy.nvim は `plugins/` 直下の Lua ファイル、および `init.lua` を含む直下のディレクトリを plugin spec として読み込みます。そのため、`plugins/` 直下に配置する `init.lua` は plugin spec またはそのリストを返す純粋な定義とし、副作用を持たせないようにします。

plugin spec 以外の内部モジュールは、`plugins/files/` や `plugins/navigation/mini-files/` のように 1 階層深いディレクトリへ配置します。内部モジュールのみを収めるディレクトリには `init.lua` を作成しません。

機能別ディレクトリの plugin spec に専用の内部モジュールを付随させる場合は、plugin spec 本体を `init.lua` に配置します。たとえば `plugins/editing/undo-glow-config/init.lua` を plugin spec とし、`plugins/editing/undo-glow-config/actions.lua` をキーマップから呼び出される操作用モジュールとして分割します。

同一のプラグインを複数の機能カテゴリから設定する場合は、各機能の plugin spec にそれぞれの `opts` とキーバインドを分散して記述します。プラグイン全体に関わる共通の初期化のみを、`plugins/` 直下の plugin spec が担当します。

## Picker の操作層

Picker を開く処理は `plugins/picker/actions.lua` に集約します。`keymaps.lua` はキー、action、説明文の対応関係のみを宣言し、Snacks などの picker オプションを直接組み立てないようにします。

ダッシュボードなどのキーマップ以外の入口からも同じ action を呼び出すことで、検索ロジックやオプションの整合性を保ちます。
