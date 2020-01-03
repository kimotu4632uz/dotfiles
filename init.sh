export MYENV=${MYENV:-$HOME/.myenv}

while read file; do
    source "$file"
done < <(find $MYENV/source -name "*.sh")

export PATH=$PATH:$MYENV/bin
