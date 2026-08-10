#!/bin/sh
cd $(dirname $0)
for dotfile in .?*
do
    if [ $dotfile != '..' ] && [ $dotfile != '.git' ] && [ $dotfile != '.claude' ]
    then
        if [ -e "$HOME/$dotfile" ]; then
            echo "バックアップを作成: $HOME/$dotfile -> $HOME/${dotfile}.bak"
            mv "$HOME/$dotfile" "$HOME/${dotfile}.bak"
        fi
        echo "シンボリックリンクを作成: $PWD/$dotfile -> $HOME/$dotfile"
        ln -s "$PWD/$dotfile" "$HOME/$dotfile"
    fi
done

# ~/.claude はセッションデータ等のGit管理外ファイルを含むため、
# ディレクトリ全体ではなく CLAUDE.md のみリンクする
mkdir -p "$HOME/.claude"
if [ -e "$HOME/.claude/CLAUDE.md" ] && [ ! -L "$HOME/.claude/CLAUDE.md" ]; then
    echo "バックアップを作成: $HOME/.claude/CLAUDE.md -> $HOME/.claude/CLAUDE.md.bak"
    mv "$HOME/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md.bak"
fi
echo "シンボリックリンクを作成: $PWD/.claude/CLAUDE.md -> $HOME/.claude/CLAUDE.md"
ln -sf "$PWD/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
