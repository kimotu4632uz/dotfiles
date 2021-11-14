#!/bin/bash -e

check_wsl() {
  type cmd.exe &> /dev/null
}

print_help() {
  echo "usage: $0 [-s SHELL]"
  exit
}

init() {
  if [ ! -d $MYENV ]; then
    git clone git@github.com:kimotu4632uz/myenv.git $MYENV
  fi

  mkdir -p $MYENV/bin/3rdparty 
}

install_shellrc() {
  local shell=$1

  cd "$MYENV/shell/$shell"

  for line in $(find . -mindepth 1); do
    if [ -f "$line" ]; then
      ln -sf "$MYENV/shell/$shell/${line#*/}" $HOME/"${line#*/}"
    else
      mkdir -p $HOME/"${line#*/}"
    fi
  done
}

install_dotfiles() {
  local dir="$1"

  for file in $(find "$dir" -maxdepth 1 -type f); do
    ln -sf "$file" $HOME/"${file##*/}"
  done
}

install_config() {
  cd $MYENV/config
  mkdir -p $HOME/.config

  for line in $(find . -mindepth 1); do
    local src="$MYENV/config/${line#*/}" 
    local dst="$HOME/.config/${line#*/}"

    if [ -f "$src" ]; then
      ln -sf "$src" "$dst"
    else
      mkdir -p "$dst"
    fi
  done
}

install_bin() {
  local dir="$1"

  for file in $(find "$dir" -maxdepth 1 -type f -name "*.src"); do
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
  local shellrc="bash"
  while getopts s:h OPT; do
    case $OPT in
      s) shellrc=$OPTARG
         ;;
      h) print_help
         ;;
      \?) print_help
         ;;
    esac
  done

  init

  install_shellrc $shellrc
  install_dotfiles "$MYENV/dotfiles"
  install_config "$MYENV/config"
  install_bin "$MYENV/bin"

  if check_wsl; then
    [ -d $MYENV/dotfiles/wsl ] && install_dotfiles "$MYENV/dotfiles/wsl"
    [ -d $MYENV/bin/wsl ] && install_bin "$MYENV/bin/wsl"
  fi

  find $MYENV/bin -type f -not -name "*.src" -exec chmod +x {} \;
}

export MYENV=${MYENV:-$HOME/.myenv}
main "$@"

