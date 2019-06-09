export MYENV=${MYENV:-$HOME/.myenv}

while read line; do
    source $line
done < <(find $MYENV/source -name "*.sh")

export PATH=$PATH:$MYENV/bin