#!/bin/bash
dotfile=[
    ".bash_profile",
    ".bashrc"
]

source=[
    "git-prompt.sh.src",
    "bashmarks.sh.src"
]

bin=[
    "24-bit-color.sh.src"
]

for file in ${dotfile[@]}; do
    ln -s src/$file $HOME/
done

for t in "source" "bin"; do
    for file in ${$t[@]}; do
        if [[ ${file#*.} == "src" ]]; then
            bash $file
            mv src/${file%.*} $t/
        else
            ln -s src/$file $t
        fi
    done
done