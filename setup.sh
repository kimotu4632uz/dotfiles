#!/bin/bash
dotfile=(
    ".bash_profile"
    ".bashrc"
    ".vimrc"
)

source=(
    "utils.sh"
    "git-prompt.sh.src"
    "bashmarks.sh.src"
)

bin=(
    "24-bit-color.sh.src"
)

export MYENV=${MYENV:-$HOME/.myenv}
git clone https://github.com/kimotu4632uz/myenv.git $MYENV
cd $MYENV

for file in ${dotfile[@]}; do
    ln -s $MYENV/src/$file $HOME/
done

for file in ${source[@]}; do
    [[ -e "source/" ]] || mkdir source/
    if [[ ${file##*.} == "src" ]]; then
        (cd src && bash $file)
        mv src/${file%.*} source/
    else
        ln -s ../src/$file source/
    fi
done

for file in ${bin[@]}; do
    [[ -e "bin/" ]] || mkdir bin/
    if [[ ${file##*.} == "src" ]]; then
        (cd src && bash $file)
        mv src/${file%.*} bin/
    else
        ln -s ../src/$file bin/
    fi
done
