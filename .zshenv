# Local
typeset -U path
path=(# Mac Homebrew
      $HOME/brew/bin(N-/)
      # System
      /bin(N-/)
      /sbin(N-/)
      # User
      $HOME/local/bin(N-/)
      # Debian GNU/Linux
      #/var/lib/gems/*/bin(N-/)
      # MacPorts / Homebrew
      /opt/local/bin(N-/)
      # Solaris
      #/opt/csw/bin(N-/)
      #/usr/sfw/bin(N-/)
      # Cygwin
      #/cygdrive/c/meadow/bin(N-/)
      # System
      /usr/local/bin(N-/)
      /usr/bin(N-/)
      /usr/sbin(N-/)
      /usr/games(N-/)
      /usr/local(N-/)
      # RCodeTools
      $HOME/.rbenv/versions/2.1.2/lib/ruby/gems/2.1.0/gems/rcodetools-0.8.5.0/bin/(N-/)
      # Temporary
      $HOME/.phantomjs/bin(N-/))

# SUDO
typeset -xT SUDO_PATH sudo_path
typeset -U sudo_path
sudo_path=({,/usr/pkg,/usr/local,/usr}/sbin(N-/))

# MAN
typeset -U manpath
manpath=(# User
         $HOME/local/share/man(N-/)
         # MacPorts / Homebrew
         /opt/local/share/man(N-/)
         # Solaris
         #/opt/csw/share/man(N-/)
         #/usr/sfw/share/man(N-/)
         # System
         /usr/local/share/man(N-/)
         /usr/share/man(N-/))

if
 type lv > /dev/null 2>&1; then
    ## Use lv
    export PAGER="lv"
else
    ## if has not lv , Use less
    export PAGER="less"
fi

# lv config
if [ "$PAGER" = "lv" ]; then
    export LV="-c -l"
else
    alias lv="$PAGER"
fi

# grep config
# if type ggrep > /dev/null 2>&1; then
#     alias grep=ggrep
# fi
# grep_version="$(grep --version | head -n 1 | sed -e 's/^[^0-9.]*\([0-9.]*\)$/\1/')"
# export GREP_OPTIONS
# GREP_OPTIONS="--binary-files=without-match"
# case "$grep_version" in
#     1.*|2.[0-4].*|2.5.[0-3])
# 	;;
#     *)
# 	GREP_OPTIONS="--directories=recurse $GREP_OPTIONS"
# 	;;
# esac
# GREP_OPTIONS="--exclude=\*.tmp $GREP_OPTIONS"
# if grep --help | grep -q -- --exclude-dir; then
#     GREP_OPTIONS="--exclude-dir=.svn $GREP_OPTIONS"
#     GREP_OPTIONS="--exclude-dir=.git $GREP_OPTIONS"
#     GREP_OPTIONS="--exclude-dir=.deps $GREP_OPTIONS"
#     GREP_OPTIONS="--exclude-dir=.libs $GREP_OPTIONS"
# fi
# if grep --help | grep -q -- --color; then
#     GREP_OPTIONS="--color=auto $GREP_OPTIONS"
# fi

export LC_COLLATE=C
export LC_CTYPE=ja_JP.UTF-8
export LC_MESSAGES=C
export LC_MONETARY=C
export LC_NUMERIC=C
export LC_TIME=C

export EDITOR=emacs

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

# nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH
