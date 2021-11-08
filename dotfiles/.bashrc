source $HOME/.bash_profile
source $HOME/.myenv/init.sh
shopt -s autocd extglob globstar direxpand

if type_q cmd.exe; then
  eval `dircolors ~/.colorrc`
fi

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

# define custom prompt
if type_q __git_ps1; then
  [[ $(id -u) = 0 ]] && ROOT_CHECK='# '
  PROMPT_COMMAND='__git_ps1 "\n\[\e[1;96m\]\w\[\e[m\]" "\n\\[\e[1;31m\]${ROOT_CHECK}\[\e[1;35m\]❯\[\e[m\] " " %s "'
  GIT_PS1_SHOWDIRTYSTATE=1
  GIT_PS1_SHOWUPSTREAM="auto"
else
  echo "please install bash-completion and git"
fi

#WSL only setting
if type_q cmd.exe; then
  export PASSWORD_STORE_DIR=${USERPROFILE:-$HOME}/.password-store
  export EDITOR=vim
fi

