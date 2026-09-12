# Karabiner-Elements キーボード設定

## 目的

macOS 上での打鍵効率向上、Vim 操作との親和性向上、誤操作防止を目的とした Karabiner-Elements の設定方針をまとめます。

## 管理場所

- 設定ファイル: `dotfiles/tools/karabiner/karabiner.json`
- 配備先: `~/.config/karabiner/karabiner.json`

## 主なリマップ内容

### 1. 単純リマップ（simple_modifications）

- **Caps Lock ➔ Escape**:
  利用頻度の低い Caps Lock キーを Escape キーとして割り当て、Vim のモード切り替えなどのホームポジション崩れを防ぎます。

### 2. 複合リマップ（complex_modifications）

- **Escape での英数自動切り替え**:
  Escape キーを押した際、Escape と同時に「英数」キーを送信します。Vim の Insert モードから Normal モードに戻る際に、日本語入力状態が残らないようにするための設定です。
- **Command キー単体押しでの「英数 / かな」切り替え**:
  - 左 Command キー単押し: 「英数」に切り替え
  - 右 Command キー単押し: 「かな」に切り替え
  - 他のキーと組み合わせた場合や長押し時は、通常の Command 修飾キーとして動作します。
- **Command + Q の長押し終了**:
  誤操作によるアプリケーションの不意な終了を防ぐため、Command + Q を一定時間長押しした場合にのみ終了シグナルを送信します。
