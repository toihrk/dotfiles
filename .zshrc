autoload -Uz colors
colors

autoload -Uz compinit
compinit

# 補完候補を詰めて表示
setopt list_packed

# 補完候補一覧でファイルの種別をマーク表示
setopt list_types

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完候補をカーソルで選択
zstyle ':completion:*:default' menu select=1

# 区切り文字の設定
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars "_-./;@"
zstyle ':zle:*' word-style unspecifie

# emacsキーバインド
bindkey -e

# Ctrl+rでヒストリーのインクリメンタルサーチ
bindkey '^r' history-incremental-pattern-search-backward

# Ctrl+Dでログアウトしてしまうことを防ぐ
setopt IGNOREEOF

# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# Ctrl+Sのロック, Ctrl+Qのロック解除を無効にする
setopt no_flow_control

# '#' 以降をコメントとして扱う
setopt interactive_comments

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# ヒストリファイルに保存するとき、すでに重複したコマンドがあったら古い方を削除する
setopt hist_save_nodups

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 補完候補が複数あるときに自動的に一覧表示する
setopt auto_menu

# 高機能なワイルドカード展開を使用する
setopt extended_glob

# cdコマンドを省略して、ディレクトリ名のみの入力で移動
setopt auto_cd

# 自動でpushdを実行
setopt auto_pushd

# pushdから重複を削除
setopt pushd_ignore_dups

# コマンドミスを修正
setopt correct

# cdの後にlsを実行
chpwd() { ls -llG }

# Enter押下後にpwd・ls・git statusの実行結果を表示
do-enter() {
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi

    echo
    echo "${fg[green]}$(pwd)${reset_color}"
    echo 
    ls -allG
    echo
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = true ]; then
        git status -sb
        echo
    fi
    zle reset-prompt
}
zle -N do-enter
bindkey '^m' do-enter

# エイリアス
alias g="git"
alias x="exit"
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ls='ls -GF'
alias ll='ls -la'
alias la='ls -a'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias df='df -h'
alias du='du -h'
alias mkdir='mkdir -p'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias h='history'
alias j='jobs -l'
alias tree='tree -C'

# プロンプトの設定
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats '%F{green}[%b]%f'
zstyle ':vcs_info:git:*' actionformats '%F{red}[%b|%a]%f'

# コマンド実行時間の計測
preexec() {
    timer=${timer:-$SECONDS}
}

precmd() {
    if [ $timer ]; then
        timer_show=$(($SECONDS - $timer))
        if [ $timer_show -ge 1 ]; then
            echo "実行時間: ${timer_show}秒"
        fi
        unset timer
    fi
    vcs_info
}

setopt prompt_subst

# 最後の2つのディレクトリを表示する関数
function shorten_pwd {
    local pwd="${PWD/#$HOME/~}"
    local parts=(${(s:/:)pwd})
    if [[ ${#parts} -gt 2 ]]; then
        echo "${parts[-2]}/${parts[-1]}"
    else
        echo "$pwd"
    fi
}

PROMPT='%F{cyan}$(shorten_pwd)%f ${vcs_info_msg_0_} %# '
