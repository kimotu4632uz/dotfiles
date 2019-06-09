## basic settings
setopt auto_cd
setopt correct


## alias
alias -g L='| less'
alias -g G='| grep'

alias la='ls -AFh'
alias ll='ls -AlFh'
alias mkdir='mkdir -p'
alias dotsync='curl -L git.io/dotsync | bash'


## delete many files    ex) zmv *.txt *.txt.bk
autoload -Uz zmv
alias zmv='noglob zmv -W'


## parse words
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " _-/:;.,{}|@"
zstyle ':zle:*' word-style unspecified  
 
 
## complition settings
autoload -Uz compinit; compinit
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin  


## history settings
setopt share_history
setopt histignorealldups
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000


## start tmux when terminal started
# change session by "prefix -> (" or "prefix -> )"
TMUX_INITIAL_SESSIONS=(
"main"
)

# if initial sessions doesn't exsist, start them
for tmux_session in ${TMUX_INITIAL_SESSIONS[@]}
do
  if ! $(tmux has-session -t ${tmux_session} 2> /dev/null)
  then
    tmux new-session -d -s ${tmux_session}
  fi
done

# if tmux doesn't run, "tmux attach"
if [ -z "$TMUX" ]
then
  tmux attach-session -t "${TMUX_INITIAL_SESSIONS[0]}"
else
fi


# zplug
. $ZPLUG_HOME/init.zsh
zplug "zplug/zplug"
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure", use:pure.zsh, as:theme
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
#zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf | zplug "b4b4r07/enhancd", use:init.sh
zplug "b4b4r07/enhancd", use:init.sh


if ! zplug check; then
    zplug install
fi

zplug load

