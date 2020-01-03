#!/bin/bash
export MYENV=${MYENV:-$HOME/.myenv}
git clone https://github.com/kimotu4632uz/myenv.git $MYENV

while read file; do
  ln -s "$file" $HOME/"${file##*/}"
done < <(find $MYENV/dotfiles -maxdepth 1 -type f)

while read file; do
  (
  source "$file"
  curl -o "${file%.*}" "$url"

  if [[ "$patch" != "" ]]; then
    patch -u "${file%.*}" < "${file%/*}/$patch"
  fi
  )
done < <(find $MYENV/{source,bin} -maxdepth 1 -type f -name "*.src")
