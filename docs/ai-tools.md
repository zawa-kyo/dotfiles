# AI ツール管理と apm 運用方針

## 目的

AI ツールごとのスキル配置を手で個別に管理せず、[apm](https://github.com/microsoft/apm) を介してスキルの追加、更新、配布、確認の手順を揃える。

対象にする AI ツールは次のとおり。

- Claude Code
- Codex
- GitHub Copilot
- Gemini CLI

## 基本方針

- グローバルなエージェント向け指示は dotfiles の `AGENTS.md` で管理する
- `AGENTS-ja.md` は日本語版として併走させるが、エージェント設定ディレクトリにはリンクしない
- `AGENTS.md` は `~/.codex/AGENTS.md` と `~/.claude/CLAUDE.md` にリンクして、Codex と Claude Code で同じ内容を読む
- スキルは apm で運用、管理する
- dotfiles では公開済みの再利用可能なスキルの依存関係を管理する
- apm の展開先は `apm/apm.lock.yaml` の `deployed_files` を正とする
- 現行のユーザー単位インストールでは `.agents/skills` と `.claude/skills` に展開する
- スキル本体は用途に応じてパブリックリポジトリ、プライベートリポジトリ、またはプロジェクト単位の apm 管理に置く
- `mise run install` で lock ファイルに従ってスキルを反映する
- `mise run upgrade` でスキルを更新し、lock ファイルも更新する

## dotfiles で管理するもの

dotfiles は公開リポジトリなので、ここで管理するスキルは公開して問題ないものに限定する。

dotfiles では `apm/` を `~/.apm` にリンクし、公開済みの再利用可能なスキルをユーザー単位に反映するための依存関係リストとして扱う。スキル本体は原則として個別の apm パッケージリポジトリに置き、dotfiles には参照と lock ファイルだけを置く。

- `apm/apm.yml`
  - インストールする公開 apm パッケージを宣言する
- `apm/apm.lock.yaml`
  - 解決済みのコミットと内容のハッシュを記録する
- `mise.toml`
  - `apm install` と `apm update` の実行入口を定義する

`apm/apm.lock.yaml` は再現性のためにコミットする。手で編集せず、apm コマンドの結果をそのまま反映する。

## 通常運用の入口

`mise run install` では次の順に処理する。

1. dotfiles 管理ファイルをリンクする
2. `mise` 管理ツールをインストールする
3. `apm install -g` を実行する
4. Bun や pre-commit など、既存のセットアップ処理を続ける

`apm install -g` は `apm/apm.lock.yaml` に従うため、通常のセットアップではスキルのバージョンを勝手に進めない。

`mise run upgrade` では apm パッケージを更新する。更新された `apm/apm.lock.yaml` は他の lock ファイルと同じくレビュー対象にする。

## 既知の TODO

- apm は Claude、Gemini、agent-skills、Copilot Cowork、Copilot App を主な対応先として扱う
- dotfiles では apm が出力する `.agents/skills` と `.claude/skills` を前提に運用する
- Codex と GitHub Copilot では、`.agents/skills` を読む環境に限ってスキルを利用できる
- dotfiles では `.codex/skills` や `.copilot/skills` への個別展開は管理しない
- 初期運用では main ブランチの最新を取り込むため、`dependencies unpinned` 警告を許容する
- スキルが安定したらタグ指定に切り替え、`dependencies unpinned` 警告が出ない状態を通常運用にする

## スキルの置き場所を決める基準

スキルを追加するときは、最初に利用範囲を決める。

| 利用範囲                                          | 管理方法                                                                   |
| ------------------------------------------------- | -------------------------------------------------------------------------- |
| 複数のパブリックリポジトリや他の人にも使える内容  | 公開 apm パッケージとして管理する                                          |
| 複数リポジトリで使うが公開したくない内容          | プライベート GitHub リポジトリの apm パッケージとして管理する              |
| 特定リポジトリの文脈に強く依存する内容            | そのリポジトリのプロジェクト単位の apm 管理に置く                          |
| dotfiles の運用にだけ必要で、公開して問題ない内容 | dotfiles 内の apm 管理に置くか、公開 apm パッケージに分ける                |
| 自分の全作業環境で使うが公開したくない内容        | dotfiles には置かず、プライベート GitHub リポジトリの apm パッケージに置く |

apm の展開先である `.agents/skills` や `.claude/skills`、旧運用で使っていた `.codex/skills` などを直接編集しない。人が編集する場所は apm パッケージ側の `.apm/skills`、プロジェクト単位の `.apm/skills`、または dotfiles の `apm/apm.yml` に限定する。

## 公開スキルの運用

公開して問題ない再利用可能なスキルは、dotfiles に直接置かず、個別の apm パッケージリポジトリで管理する。

対象例:

- `review-essential-code`
- `suggest-commit-messages`

各スキルリポジトリは apm パッケージとして構成し、dotfiles 側の `apm/apm.yml` から GitHub 依存関係として参照する。

例:

```yaml
dependencies:
  apm:
    - zawa-kyo/skills/meta/review-essential-code
    - zawa-kyo/skills/meta/suggest-commit-messages
    - zawa-kyo/skills/meta/fluent-japanese-writing
```

タグを指定しておくと、意図しない更新を避けやすい。実際に使われるコミットは lock ファイルに記録される。

公開スキルを更新するときは、スキルリポジトリ側で変更、確認、タグ作成まで行う。その後 dotfiles 側で apm 更新タスクを実行し、`apm/apm.lock.yaml` の差分を確認する。

## プライベートリポジトリ内だけで使うスキル

特定のプライベートリポジトリ内でだけ使うスキルは、そのリポジトリ自身のプロジェクト単位の apm 管理に置く。dotfiles 側には追加しない。

例:

```text
private-repo/
  apm.yml
  apm.lock.yaml
  .apm/
    skills/
      repo-private-skill/
        SKILL.md
```

そのリポジトリで `apm install` を実行する。`-g` は付けない。

この形にすると、リポジトリ内では `.apm/skills` を編集場所とし、各ツール向けの配置は apm の処理結果として扱える。

プロジェクト単位のスキルは、そのリポジトリのコード、設計、運用、ドメイン知識に強く依存するものに限定する。複数リポジトリで同じ内容が必要になった場合は、プライベートな再利用可能スキルへの分離を検討する。

## プライベートな再利用可能スキルの運用

複数リポジトリで共有したいが公開したくないスキルは、プライベート GitHub リポジトリの apm パッケージとして管理する。

各プライベートプロジェクトの `apm.yml` からプライベートリポジトリを依存関係として参照する。公開 dotfiles からプライベート依存関係は参照しない。

認証情報は環境変数で渡し、リポジトリには含めない。

例:

```yaml
dependencies:
  apm:
    - zawa-kyo/private-skills/repo-review-helper#v1.0.0
```

プライベート依存関係は便利だが、参照側のリポジトリを使う全員が取得権限を持つ必要がある。チームで使う場合は、パッケージリポジトリの権限設計も運用に含める。

自分の環境だけで使うプライベートな再利用可能スキルも、公開 dotfiles には書かない。必要であればプライベートな管理リポジトリ側でユーザー単位の apm 設定を持つ。

## スキルを追加するときの手順

1. 利用範囲を決める
2. 置き場所を選ぶ
3. apm パッケージまたはプロジェクト単位の `.apm/skills/<skill-name>/SKILL.md` を追加する
4. 必要なら `SKILL-ja.md` や `agents/openai.yaml` も追加する
5. 参照側の `apm.yml` に依存関係を追加する
6. ユーザー単位なら dotfiles の apm 更新タスク、プロジェクト単位なら `apm update` を実行する
7. lock ファイルの差分を確認する
8. 実際に対象 AI ツールからスキルが見えることを確認する

## スキルを更新するときの手順

1. スキルの管理リポジトリで内容を変更する
2. そのリポジトリで必要な確認を行う
3. 再利用可能なスキルならタグを作成する
4. 参照側で apm 更新タスクを実行する
5. lock ファイルのコミット、内容のハッシュ、展開先の差分を確認する
6. 変更したスキルを対象 AI ツールで実行し、期待する文脈で反応するか確認する

スキルの中身だけを変更した場合でも、参照側は lock ファイル更新を通して取り込む。ツール固有の出力先を直接書き換えて調整しない。

## 既存スキルの扱い

dotfiles で共通利用するスキルは、公開 apm 依存関係として扱う。dotfiles 内に直接スキル本体を置く方式は避ける。

旧 `ai/skills/` 配下にあったスキルを継続利用する場合も、運用上は公開 apm パッケージリポジトリに分けてから `apm/apm.yml` で参照する。移動後は `ai/skills/` を日常的な編集場所として使わない。

例外として、dotfiles の運用にしか意味がない補助スキルが必要になった場合は、dotfiles 内の apm 管理に置いてよい。ただし公開リポジトリに含める以上、内容は公開可能なものに限定する。

## 実装上の注意

- apm パッケージの中身を変えたら、参照側では apm 更新タスクを使って lock ファイルを更新する
- `apm.lock.yaml` はフォーマッタの対象外にする
- 認証トークンやマシン固有の値はコミットしない
- 公開 dotfiles からプライベート依存関係を参照しない
- ツール固有の出力先を手で編集しない
- リポジトリ内だけのスキルにはプロジェクト単位の管理を使い、ユーザー全体で使うスキルにはユーザー単位の管理を使う
