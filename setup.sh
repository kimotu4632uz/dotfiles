#!/bin/bash
export MYENV=${MYENV:-$HOME/.myenv}
git clone git@github.com:kimotu4632uz/myenv.git $MYENV

while read file; do
  ln -sf "$file" $HOME/"${file##*/}"
done < <(find $MYENV/dotfiles -maxdepth 1 -type f)

if [ ! -d $MYENV/bin/3rdparty ]; then
  mkdir -p $MYENV/bin/3rdparty 
fi

if [ ! -d $MYENV/source/3rdparty ]; then
  mkdir -p $MYENV/source/3rdparty 
fi

while read file; do
  (
  source "$file"
  curl -o "${file%.*}" "$url"

  if [[ "$patch" != "" ]]; then
    patch --backup-if-mismatch -u "${file%.*}" < "${file%/*}/$patch"
  fi

  mv "${file%.*}" $(echo "$file" | sed -E 's/^(.*)\/(.*)\.(.*)$/\1\/3rdparty\/\2/')
  )
done < <(find $MYENV/{source,bin} -maxdepth 1 -type f -name "*.src")

find $MYENV/bin -type f -not -name "*.src" -exec chmod +x {} \;
