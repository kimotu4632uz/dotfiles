source $HOME/.myenv/env
shopt -s autocd extglob globstar direxpand

## alias
alias ls='ls --color=auto'
alias la='ls --color=auto -AFh'
alias ll='ls --color=auto -AlFh'
alias grep='grep --color'
alias mkdir='mkdir -p'
alias vi='vim'

alias diff_up="diff -up"
alias diff_dir="diff -uprN"

#WSL only setting
if type_q cmd.exe; then
  export PASSWORD_STORE_DIR=${USERPROFILE:-$HOME}/.password-store
fi

eval "$(starship init bash)"
