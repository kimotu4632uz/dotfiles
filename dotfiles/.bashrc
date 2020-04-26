source $HOME/.bash_profile
source $HOME/.myenv/init.sh
shopt -s autocd extglob globstar direxpand

## alias
alias L='| less'
alias G='| grep'
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
    $MYENV/bin/gpg-agent-relay.sh &
    $MYENV/bin/ssh-agent-relay.sh &
#    ss -a | grep -q $SSH_AUTH_SOCK || {
#        rm -f $SSH_AUTH_SOCK
#        ( setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"/mnt/c/Users/kimot/Programs/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork & )
#    }
#    ss -a | grep -q $GPG_SSH_AGENT || {
#        rm -f $GPG_SSH_AGENT
#        ( setsid socat UNIX-LISTEN:$GPG_SSH_AGENT,fork EXEC:"${NPIPERELAY} -ei -ep -s -a '${WIN_GPG}/S.gpg-agent.ssh'",nofork & )
#        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
#    }
fi

