export LANG=ja_JP.UTF-8
export TERM=xterm-256color

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.cache

export ZPLUG_HOME=$XDG_CACHE_HOME/zplug

export PAGER=less
export LESS="-S -N -x4 -R -i -M"
export LESS_TERMCAP_mb=$'\E[01;31m'      # Begins blinking.
export LESS_TERMCAP_md=$'\E[01;31m'      # Begins bold.
export LESS_TERMCAP_me=$'\E[0m'          # Ends mode.
export LESS_TERMCAP_se=$'\E[0m'          # Ends standout-mode.
export LESS_TERMCAP_so=$'\E[00;47;30m'   # Begins standout-mode.
export LESS_TERMCAP_ue=$'\E[0m'          # Ends underline.
export LESS_TERMCAP_us=$'\E[01;32m'      # Begins underline.

export MANPATH=/opt/texlive/2018/texmf-dist/doc/man
export INFOPATH=/opt/texlive/2018/texmf-dist/doc/info
export PATH="$PATH:/opt/texlive/2018/bin/aarch64-linux"

export PATH="$PATH:$HOME/.local/bin"

