#!/bin/bash -e

SSH_AGENT=$HOME/.ssh/ssh-agent.sock
NPIPERELAY="/mnt/c/Users/kimot/Programs/npiperelay.exe"
PIDSTORE="$HOME/.ssh-agent-relay.pid"

trap "echo '' > $PIDSTORE; exit 1" 1 2 3 15

if [[ -e $PIDSTORE && -n $(cat $PIDSTORE) ]]; then
    ps -p $(cat $PIDSTORE) > /dev/null && exit 0
fi

echo $$ > $PIDSTORE

rm -f $SSH_AGENT
socat UNIX-LISTEN:$SSH_AGENT,fork EXEC:"$NPIPERELAY -ei -s //./pipe/ssh-pageant",nofork
SSH_AGENT_PID=$!

wait $SSH_AGENT_PID

