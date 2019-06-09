#ignorespace+ignoredups = ignoreboth
export HISTCONTROL=ignoreboth

export TERM=xterm-256color

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.cache

export PAGER=less
export LESS="-S -N -x4 -R -i -M"
export LESS_TERMCAP_mb=$'\E[01;31m'      # Begins blinking.
export LESS_TERMCAP_md=$'\E[01;31m'      # Begins bold.
export LESS_TERMCAP_me=$'\E[0m'          # Ends mode.
export LESS_TERMCAP_se=$'\E[0m'          # Ends standout-mode.
export LESS_TERMCAP_so=$'\E[00;47;30m'   # Begins standout-mode.
export LESS_TERMCAP_ue=$'\E[0m'          # Ends underline.
export LESS_TERMCAP_us=$'\E[01;32m'      # Begins underline.

export PYTHONPATH="$HOME/pylib"

export USE_CCACHE=1
export CCACHE_DIR=$HOME/.ccache
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$PREFIX/lib64"

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

