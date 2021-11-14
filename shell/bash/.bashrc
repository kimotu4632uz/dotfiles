source $HOME/.bash_profile
source $HOME/.myenv/init.sh
shopt -s autocd extglob globstar direxpand

## alias
alias ls='ls --color=auto'
alias la='ls -AFh'
alias ll='ls -AlFh'
alias grep='grep --color'
alias mkdir='mkdir -p'
alias vi='vim'

alias CRLF2LF="sed -i -e 's/\r//g' "
alias LF2CRLF="sed -i -e 's/$/\r/' "

alias tab2space="expand -t 4"
alias space2tab="unexpand -t 4"

alias diff_up="diff -up"
alias diff_dir="diff -uprN"

#WSL only setting
if type_q cmd.exe; then
  export PASSWORD_STORE_DIR=${USERPROFILE:-$HOME}/.password-store
  export EDITOR=vim
fi

eval "$(starship init bash)"
