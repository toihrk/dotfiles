#!/bin/sh
cd $(dirname $0)
for dotfile in .?*
do
    if [ $dotfile != '..' ] && [ $dotfile != '.git' ]
    then
        if [ -e "$HOME/$dotfile" ]; then
            echo "バックアップを作成: $HOME/$dotfile -> $HOME/${dotfile}.bak"
            mv "$HOME/$dotfile" "$HOME/${dotfile}.bak"
        fi
        echo "シンボリックリンクを作成: $PWD/$dotfile -> $HOME/$dotfile"
        ln -s "$PWD/$dotfile" "$HOME/$dotfile"
    fi
done
