#!/bin/bash
export MYENV=${MYENV:-$HOME/.myenv}
git clone https://github.com/kimotu4632uz/myenv.git $MYENV

while read file; do
  ln -s "$file" $HOME/"${file##*/}"
done < <(find $MYENV/dotfiles -maxdepth 1 -type f)

if [ ! -d $MYENV/bin/3rdparty ]; then
  mkdir $MYENV/bin/3rdparty 
fi

if [ ! -d $MYENV/source/3rdparty ]; then
  mkdir $MYENV/source/3rdparty 
fi

while read file; do
  (
  source "$file"
  curl -o "${file%.*}" "$url"

  if [[ "$patch" != "" ]]; then
    patch -u "${file%.*}" < "${file%/*}/$patch"
  fi

  mv "${file%.*}" $(echo "${file%.*}" | sed -E 's/^(.*)\/(.*)\.(.*)$/\1\/3rdparty\/\2/')
  )
done < <(find $MYENV/{source,bin} -maxdepth 1 -type f -name "*.src")

find $MYENV/bin -name "*.sh" -exec chmod +x {} \;
