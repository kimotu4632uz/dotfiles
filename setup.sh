#!/bin/bash

check_wsl() {
  type cmd.exe &> /dev/null
}

init() {
  export MYENV=${MYENV:-$HOME/.myenv}

  if [ ! -d $MYENV ]; then
    git clone git@github.com:kimotu4632uz/myenv.git $MYENV
  fi

  mkdir -p $MYENV/{bin,source}/3rdparty 
}

install_dotfiles() {
  while read file; do
    ln -sf "$file" $HOME/"${file##*/}"
  done
}

install_bins() {
  while read file; do
    (
    source "$file"
    curl -o "${file%.*}" "$url"
  
    if [[ "$patch" != "" ]]; then
      patch --backup-if-mismatch -u "${file%.*}" < "${file%/*}/$patch"
    fi
  
    mv "${file%.*}" $(echo "$file" | sed -E 's/^((.*)\/wsl|(.*))\/(.*)\.(.*)$/\2\3\/3rdparty\/\4/')
    )
  done
}

main() {
  init

  find $MYENV/dotfiles -maxdepth 1 -type f | install_dotfiles
  if check_wsl && [ -d $MYENV/dotfiles/wsl ]; then
    find $MYENV/dotfiles/wsl -maxdepth 1 -type f | install_dotfiles
  fi

  find $MYENV/{bin,source} -maxdepth 1 -type f -name "*.src" | install_bins
  if check_wsl && [ -d $MYENV/bin/wsl ]; then
    find $MYENV/bin/wsl -maxdepth 1 -type f -name "*.src" | install_bins
  fi
  if check_wsl && [ -d $MYENV/source/wsl ]; then
    find $MYENV/source/wsl -maxdepth 1 -type f -name "*.src" | install_bins
  fi

  find $MYENV/bin -type f -not -name "*.src" -exec chmod +x {} \;
}

main

