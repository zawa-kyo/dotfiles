---
name: suggest-commit-messages
description: 現在の Git 差分から、簡潔な英語の Conventional Commit メッセージ候補を提案する。ステージング済みの変更があればそれを優先し、なければ未ステージングの変更と未追跡ファイルを対象にする。コミットメッセージ案、ステージング済み差分からの候補、または「staging されている差分からコミットメッセージを考えて」のような依頼で、回答前に Git の状態を確認する必要がある場合に使う。
---

# コミットメッセージ候補の提案

## 言語バージョン

このファイルと `SKILL.md` は同じ skill を説明します。どちらかを変更する場合は、同じ変更の中でもう一方も更新し、英語版と日本語版の内容をそろえます。その際、それぞれの言語として自然な表現を保ちます。

## 概要

リポジトリの現在の変更から、簡潔な英語のコミットメッセージ候補を少数作成します。ステージング済みの変更を優先しますが、何もステージされていない場合は、未追跡ファイルを含む未ステージングの変更全体を確認します。以前の文脈で cached、staged、unstaged、untracked などの内容に触れていても、実行時には必ず Git の状態を確認し直します。

## ワークフロー

1. `git status --short` でリポジトリの状態を確認する。
2. まず `git diff --cached --stat` と `git diff --cached` でステージング済み差分を確認する。
3. ステージング済み差分がない場合は、`git diff --stat` と `git diff` で追跡済みファイルの未ステージング差分全体を確認する。
4. `git status --short` または `git ls-files --others --exclude-standard` で未追跡ファイルも確認する。関連する未追跡テキストファイルごとに、意図を理解できるだけの内容を読む。
5. ステージング済み変更、追跡済みファイルの未ステージング変更、未追跡ファイルのいずれも存在しない場合は、Git の変更が見つからなかったことを伝え、コミットメッセージを作り出さない。
6. 選択した変更の主な意図を推測する。feature、fix、refactor、style、chore、docs、test、build のどれに当たるかも含めて判断する。
7. デフォルトでは Conventional Commit 形式で、簡潔な英語のコミットメッセージ候補を 3-6 個生成する。
8. 候補を列挙した後、変更内容への適合度と自然な英語表現を踏まえて、最もよいメッセージを 1 つ推薦する。
9. ユーザーが本文を求めていない限り、1 行のメッセージを優先する。subject は簡潔で行動を表す表現にし、末尾にピリオドを付けない。
10. 選択した変更に無関係な作業が混在している場合は、候補を変更領域ごとに分けるか、コミットを分割したほうが明確かもしれないと伝える。

## スタイル

- `feat`、`fix`、`refactor`、`style`、`chore`、`docs`、`test`、`build`、`ci` など、小文字の Conventional Commit type を使う。
- `type:` の後に続く subject の最初の単語は大文字で始める。
- 明確さのために必要な場合を除き、scope は付けない。
- type は、ユーザーから見た主な意図で選ぶ。ドキュメントのみの変更は `docs`、挙動の修正は `fix`、新しい能力は `feat`、挙動を変えない内部整理は `refactor`、フォーマットのみの変更は `style`、テストは `test`、ビルドや CI 基盤は `build` または `ci`、依存関係・ツール・保守作業で他に当てはまらないものは `chore` とする。
- 推薦メッセージを選ぶときは、選択した変更を最も直接的に表し、英語話者のメンテナーにとって自然に聞こえる候補を優先する。
- ユーザーの簡潔さの好みに合わせる。よい例:
  - `feat: Simplify eza abbreviations`
  - `feat: Limit mise lockfiles to supported platforms`
  - `refactor: Move CLI tools from Homebrew to mise`
- 最終回答で差分を説明しすぎない。ユーザーが求めているのは候補なので、候補を先に出す。

## 最終回答

ユーザーが別の指定をしない限り、回答本文はユーザーの言語に合わせます。ただし、コミットメッセージ自体は英語のままにします。通常は、簡潔な箇条書きが最適です。

```text
staged diff を確認しました。以下がコミットメッセージの候補です。

- feat: Simplify eza abbreviations
- feat: Limit mise lockfiles to supported platforms
- refactor: Move CLI tools from Homebrew to mise

もっとも自然なものは次のとおりです。

- feat: Limit mise lockfiles to supported platforms
```

ステージング済み変更がない場合は、フォールバックしたことを明示します。

```text
ステージング済みファイルが存在しなかったため、未ステージングの変更と未追跡ファイルを確認しました。以下がコミットメッセージの候補です。

- docs: Clarify commit message suggestion workflow
- docs: Fall back to unstaged changes for commit message suggestions
- docs: Update skill guidance for unstaged diffs

もっとも自然なものは次のとおりです。

- docs: Fall back to unstaged changes for commit message suggestions
```
