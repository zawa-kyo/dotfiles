# AI ツールと apm

## 目的

AI ツールの共通設定とスキルの依存関係を一か所で管理し、各ツールの展開先を手作業で同期しないようにします。

## 管理範囲

| 対象                   | 管理場所                                | 反映先                                        |
| ---------------------- | --------------------------------------- | --------------------------------------------- |
| 共通のエージェント指示 | `dotfiles/ai/instructions/AGENTS.md`    | `~/.codex/AGENTS.md` と `~/.claude/CLAUDE.md` |
| Claude Code の実行許可 | `dotfiles/ai/claude/settings.json`      | `~/.claude/settings.json`                     |
| Codex の実行許可       | `dotfiles/ai/codex/rules/default.rules` | `~/.codex/rules/default.rules`                |
| apm の依存関係         | `dotfiles/ai/apm/apm.yml`               | `~/.apm/apm.yml`                              |
| apm の設定             | `dotfiles/ai/apm/config.json`           | `~/.apm/config.json`                          |
| apm の解決結果         | `dotfiles/ai/apm/apm.lock.yaml`         | `~/.apm/apm.lock.yaml`                        |

`AGENTS-ja.md` は共通指示の日本語版として管理しますが、エージェント設定ディレクトリにはリンクしません。実行許可の形式はツールごとに異なるため、共通形式へ変換せず、各ツールの設定ファイルをそのまま管理します。

## apm の配備

`apm.yml` と `config.json` は、mise の `symlink-each` で `~/.apm` へリンクします。apm が書き換える `apm.lock.yaml` は `copy` で配備し、更新後に宣言元へ戻します。

`~/.apm` は通常のディレクトリとして使い、`apm_modules/` などの生成物はリポジトリへ含めません。スキルの展開結果は `apm.lock.yaml` の `deployed_files` を基準に確認します。

初回セットアップでは、`mise bootstrap` が lock ファイルに従ってユーザー単位のスキルを反映します。

依存関係の更新には、リポジトリの更新タスクを使います。このタスクは apm の更新結果を `dotfiles/ai/apm/apm.lock.yaml` へ戻します。

```sh
mise run --continue-on-error upgrade
```

更新された lock ファイルは手で編集せず、ほかの依存関係更新と同じように差分を確認してコミットします。

## スキルの置き場所

スキルの利用範囲に合わせて管理場所を選びます。

| 利用範囲                              | 管理場所                                                     |
| ------------------------------------- | ------------------------------------------------------------ |
| 公開でき、複数リポジトリで再利用する  | 公開 apm パッケージ                                          |
| 公開せず、複数リポジトリで再利用する  | プライベートリポジトリの apm パッケージ                      |
| 特定リポジトリの文脈に依存する        | そのリポジトリのプロジェクト単位の apm 管理                  |
| dotfiles のユーザー環境で共通利用する | `dotfiles/ai/apm/apm.yml` から参照するユーザー単位の依存関係 |
| 一回限りで再利用しない                | ユーザーのプロンプト                                         |

このリポジトリは公開されているため、`apm.yml` から参照するのは公開して問題ない依存関係だけにします。スキル本体は原則として apm パッケージ側で管理し、dotfiles には依存関係と lock ファイルだけを置きます。

`.agents/skills` や `.claude/skills` など、apm の展開先を直接編集しません。プロジェクト固有のスキルは、そのリポジトリの `.apm/skills` または依存先のパッケージで編集します。

## 知識と手順

- 作業全体で参照する設計や規約は、`AGENTS.md` または `docs/` に置く
- 特定の作業でだけ必要な手順は、利用範囲に応じたスキルへ置く
- 長い補足資料は、必要なときだけ読むスキルの `references/` または `docs/` に置く
- `AGENTS.md` には詳細を重複させず、参照先と作業領域ごとの案内を残す

## 依存関係を変更する

1. スキルの利用範囲を決め、管理場所を選ぶ
2. 管理元の apm パッケージまたはプロジェクト単位のスキルを変更する
3. 参照側の `apm.yml` を更新する
4. ユーザー単位なら dotfiles の更新タスク、プロジェクト単位なら `apm update` を実行する
5. lock ファイルのコミット、内容のハッシュ、展開先を確認する
6. 対象の AI ツールからスキルを実行して確認する

認証トークンやマシン固有の値はコミットしません。公開 dotfiles からプライベート依存関係を参照しないでください。

## 現在の制約

- ユーザー単位のインストールでは、apm が出力する `.agents/skills` と `.claude/skills` を使う
- Codex や GitHub Copilot では、`.agents/skills` を読む環境でスキルを利用する
- `.codex/skills` や `.copilot/skills` への個別展開は管理しない
- `apm.yml` の依存関係はバージョンを固定していないため、更新時に lock ファイルの差分を確認する
