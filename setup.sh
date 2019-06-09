#!/bin/bash
dotfile=[
    ".bash_profile",
    ".bashrc"
]

source=[
    "utils.sh",
    "git-prompt.sh.src",
    "bashmarks.sh.src"
]

bin=[
    "24-bit-color.sh.src"
]

export MYENV=${MYENV:-$HOME/.myenv}
git clone https://github.com/kimotu4632uz/myenv.git $MYENV
cd $MYEMV

for file in ${dotfile[@]}; do
    ln -s src/$file $HOME/
done

for t in "source" "bin"; do
    for file in ${$t[@]}; do
        [[ $t ]] || mkdir $t
        if [[ ${file#*.} == "src" ]]; then
            bash $t/$file
            mv src/${file%.*} $t/
        else
            ln -s src/$file $t/
        fi
    done
done