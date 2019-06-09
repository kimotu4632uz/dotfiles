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

# define custom prompt
if type_q __git_ps1; then
    [[ $(id -u) = 0 ]] && ROOT_CHECK='# '
    PROMPT_COMMAND='__git_ps1 "\n\[\e[1;96m\]\w\[\e[m\]" "\n\\[\e[1;31m\]${ROOT_CHECK}\[\e[1;35m\]❯\[\e[m\] " " %s "'
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWUPSTREAM="auto"
else
    echo "please install bash-completion and git"
fi


## start tmux when terminal started
# change session by "prefix -> (" or "prefix -> )"

if type_q tmux; then
    TMUX_INITIAL_SESSIONS=("main" "sub")

    # if initial sessions doesn't exsist, start them
    for tmux_session in ${TMUX_INITIAL_SESSIONS[@]}; do
        if ! $(tmux has-session -t $tmux_session &> /dev/null); then
            tmux new-session -d -s $tmux_session
        fi
    done

    # if tmux doesn't run, "tmux attach"
    [ "$TMUX" ] || tmux attach-session -t "${TMUX_INITIAL_SESSIONS[0]}"
fi

