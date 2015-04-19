# Alias
alias where="command -v"

alias j="jobs -l"

alias ls="ls"
alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"

alias du="du -h"
alias df="df -h"

alias su="su -l"

alias vi="emacs"
alias vim="emacs"

alias g='git'
alias r='rails'
alias be="bundle exec"

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias rm="rm -i"
alias rmback="rm *~;rm .*~;rm *.bak"
alias rmstore="rm .DS_Store; rm */.DS_Store"
alias rmstorer="rm **/.DS_Store"

alias h="history"
alias x="exit"

# forbid C-s
stty stop undef

# History
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history
function history-all { history -E 1 }

setopt share_history

# Auto complete
autoload -U compinit
compinit

# Case insensitive complete
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Prompt
PROMPT="%B %(?.%{$fg[green]%}.%{$fg[blue]%})%(?!(*'-') <!(*;-;%)? <)%{${reset_color}%}%b "
RPROMPT="[%m:%n %~]"
SPROMPT="correct: %R -> %r ? "

case "${TERM}" in
kterm*|xterm)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac

# Some settings
setopt autopushd
setopt auto_list
setopt auto_param_keys
setopt auto_param_slash
setopt hist_ignore_dups
setopt magic_equal_subst
setopt mark_dirs
function chpwd() { ls }
setopt auto_cd

### Ls Color ###
export LSCOLORS=Exfxcxdxbxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export ZLS_COLORS=$LS_COLORS
export CLICOLOR=true
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

### Enter setting ###
function do_enter() {
    if [ -n "$BUFFER" ]; then
        zle accept-line
        return 0
    fi
    echo
    ls -la
    # ls_abbrev
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
        echo
        echo -e "\e[0;33m--- git status ---\e[0m"
        git status -sb
    fi
    zle reset-prompt
    return 0
}
zle -N do_enter
bindkey '^m' do_enter

### RBENV ###
export RUBY_CONFIGURE_OPTS="--enable-shared --with-readline-dir=$(brew --prefix readline) --with-openssl-dir=$(brew --prefix openssl) --with-libyaml-dir=$(brew --prefix libyaml)"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

### npm ###
source ~/.npm_completion

# Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x
export COCOS_CONSOLE_ROOT=/Users/hiroki/Development/lib/cocos2d-x-3.3/tools/cocos2d-console/bin
export PATH=$COCOS_CONSOLE_ROOT:$PATH

# Add environment variable COCOS_X_ROOT for cocos2d-x
export COCOS_X_ROOT=/Users/hiroki/Development/lib/cocos2d-x-3.3
export PATH=$COCOS_X_ROOT:$PATH

# Add environment variable COCOS_TEMPLATES_ROOT for cocos2d-x
export COCOS_TEMPLATES_ROOT=/Users/hiroki/Development/lib/cocos2d-x-3.3/templates
export PATH=$COCOS_TEMPLATES_ROOT:$PATH
