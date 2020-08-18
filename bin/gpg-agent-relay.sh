#!/bin/bash -e

GPG_AGENT=$HOME/.gnupg/S.gpg-agent
WIN_GPG="C:/Users/${USERPROFILE##*/}/AppData/Roaming/gnupg"
NPIPERELAY="$USERPROFILE/Programs/npiperelay.exe"
PIDSTORE="$HOME/.gpg-agent-relay.pid"

trap "echo '' > $PIDSTORE; exit 1" 1 2 3 15

if [[ -e $PIDSTORE && -n $(cat $PIDSTORE) ]]; then
    ps -p $(cat $PIDSTORE) > /dev/null && exit 0
fi

echo $$ > $PIDSTORE

rm -f $GPG_AGENT
socat UNIX-LISTEN:$GPG_AGENT,fork EXEC:"${NPIPERELAY} -ep -ei -s -a '${WIN_GPG}/S.gpg-agent'",nofork
GPG_AGENT_PID=$!

wait $GPG_AGENT_PID

