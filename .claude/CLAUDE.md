# CLAUDE.md - Claude Code による開発ガイドライン

## 応答言語

- 日本語で応答すること
- コード、ログ、エラーメッセージ、技術用語は原文を維持する
    - 必要に応じて日本語による解説を付加してよい

## 応答スタイル

- 簡潔・明瞭を徹底する
- 冗長な説明、不要な前置き、過剰な丁寧表現を避ける
- 変更報告は箇条書きで要点のみ
- 長文説明より構造化された出力を優先する
- 編集を実施したファイルがあればその一覧を表示する

## 曖昧な指示への対応

推測による作業を禁止する。

- 指示が曖昧または不明確な場合、推測して作業を進めてはならない
- 不明な点は「不明」と明示する
- ユーザーへ質問し、回答を得るまで該当作業を保留する
- AskUserQuestionツールが利用可能な場合は積極的に使用する
  - AskUserQuestionツールでの選択肢の説明パラメータ(`questions[i].options[j].description`)には「選択肢のユーザーの選択が推奨されるかどうか」「選択肢をユーザーが選択した際にどのような影響があるのか」を説明する

## 安全性

- 承認なしの破壊的操作（ファイル削除、上書き等）を行わない
- サンドボックス外への書き込みを行わない
- 機密情報（APIキー、パスワード、認証情報等）を出力しない

## 設定の優先順位

プロジェクト固有の`CLAUDE.md`が存在する場合、その設定を優先する。

- プロジェクト設定がグローバル設定と競合する場合、プロジェクト設定に従う
- プロジェクト設定に記載がない項目は、本グローバル設定に従う

## プロジェクト固有CLAUDE.md作成ガイドライン

プロジェクトのルートに`CLAUDE.md`を配置する際は以下を考慮する：

- プロジェクト固有の技術スタック、フレームワーク、ライブラリを明記する
- コーディング規約（命名規則、フォーマッタ、リンター設定等）を定義する
- ディレクトリ構成とその役割を説明する
- テスト方針（実行コマンド、カバレッジ要件等）を記載する
- コミットメッセージ規約があれば明記する

## Git Worktree 運用

新しい作業や別文脈の作業を開始する際、Git Worktreeの作成を推奨する。

### 推奨タイミング

- 新機能の開発開始時
- バグ修正で別ブランチが必要な場合
- 既存の作業と並行して別タスクを進める場合
- レビュー用に別ブランチをチェックアウトしたい場合

### ディレクトリ構造

```
~/dev/src/
├── github.com/    # メインリポジトリ群（git clone先）
│   └── {repo-org}/{repo-name}/
└── worktree/      # 全リポジトリのworktreeを集約
    └── {repo-org}--{repo-name}--{branch-name}/
```

### 命名規則

worktreeディレクトリ名: `{repo-org}--{repo-name}--{branch-name-with-slash-replaced}`

- セパレータ: `--`（ダブルハイフン）
- ブランチ名の `/` は `-` に置換

### 作成手順（分岐元の最新化を含む）

worktree作成時は、必ず `git fetch` でリモートの分岐元ブランチを最新化し、`origin/main` から直接分岐する。
ローカル `main` のチェックアウト状態に依存しないため、ローカル `main` の更新（checkout / pull）は不要。

```bash
# 新規作成（origin/main を最新化してから分岐）
cd ~/dev/src/github.com/{repo-org}/{repo-name}
BRANCH="feature/example"
git fetch origin
git worktree add ~/dev/src/worktree/{repo-org}--{repo-name}--${BRANCH//\//-} -b $BRANCH origin/main

# 一覧確認
git worktree list

# 削除
git worktree remove ~/dev/src/worktree/{repo-org}--{repo-name}--{branch-name}
```

- 分岐元が `main` 以外（`develop` 等）の場合も同様に `origin/{base-branch}` を指定する

### 注意事項

- worktree作成時は `git fetch origin` を省略しない（古いコミットからの分岐を防ぐ）
- worktree間でのブランチ切り替え（checkout）は禁止
- 作業完了後は `git worktree remove` で削除
- メインリポジトリでは原則 `main` または `develop` ブランチのみ

### Claude Code セッションの運用

Claude Code の `--resume` オプションはプロジェクトパスに紐づくため、Worktree では元セッションを引き継げない。
以下の方式でコンテキストを引き継ぐ。

#### Worktree 作成後のセッション起動

1. 現セッションで Worktree を作成
2. 「Worktree 用の起動コマンドを生成して」と依頼
3. Claude がコンテキストを要約した `--append-system-prompt` 付きコマンドを出力
4. ユーザーが Worktree ディレクトリで実行

#### 起動コマンドの形式

```bash
cd ~/dev/src/worktree/{worktree-name} && claude --append-system-prompt '
## 引き継ぎコンテキスト

### 背景
（元セッションでの議論の背景）

### 検討済み事項
（既に検討・決定した内容）

### 次のステップ
（Worktree で実施すべき作業）
'
```

#### 原則

- 1 Worktree = 1 セッション
- セッション内での `cd` によるディレクトリ変更は避ける
- コンテキストはファイル保存せず、起動コマンドに含める（Git 管理外を維持）
