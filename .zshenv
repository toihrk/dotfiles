# PATH設定 必要最低限
typeset -aU _path
_path=(
    $HOME/dev/bin(N-/)
    /opt/homebrew/bin(N-/)
    /opt/homebrew/sbin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    $path
)

typeset -U path
path=($_path)

# 基本設定
## ロケール設定
export LANG=ja_JP.UTF-8
export LC_MESSAGES=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8
export LC_COLLATE=ja_JP.UTF-8
export LC_TIME=ja_JP.UTF-8
export LC_NUMERIC=ja_JP.UTF-8
export LC_MONETARY=ja_JP.UTF-8

## エディタ設定
export EDITOR="code --wait"
export VISUAL="code --wait"

## ページャー設定
export PAGER="less"
export LESS='-R'

# 表示設定
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='di=01;36:ln=01;35:so=01;32:ex=01;31:bd=40;33;01:cd=40;33;01:su=37;41:sg=30;43:tw=30;42:ow=34;42'
export ZLS_COLORS=$LS_COLORS
export CLICOLOR=true
export TERM=xterm-256color

# ヒストリ設定
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# ディレクトリ設定
export cdpath=(~)
