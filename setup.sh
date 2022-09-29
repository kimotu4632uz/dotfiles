#!/bin/bash -e

PKGFILE="pkgs.txt"
PKGMGR="yay"
PKGMGR_ARG=("-S" "--needed" "--noconfirm")

BLACKLIST=("$PKGFILE")

SCRIPT_DIR="$(cd ${0%/*}; pwd)"


install_src() {
  local src="$1"
  local dst="$2"

  (
    source "$src"

    curl -L -o "$dst" "$url"
  
    if [[ ! -z "$chmod" ]]; then
      chmod $chmod "$dst"
    fi
  )
}


install_module() {
  local module="$1"
  local blacklist_str="$(IFS=$'\n'; echo "${BLACKLIST[*]}")"

  echo "install module ${module}..."

  # dotfiles
  for line in $(cd "$SCRIPT_DIR/$module" && find . -mindepth 1); do
    local entry="${line#*/}"
    local entry_fname="${entry##*/}"

    local src="$SCRIPT_DIR/$module/$entry"
    local dst="$HOME/.$entry"

    if [[ -f "$src" ]]; then
      # ignore if in blacklist
      if ! echo "$blacklist_str" | grep -xq "$entry_fname"; then 

        # if suffix is "src"
        if [[ "${entry##*.}" == "src" ]]; then
          echo "Download ${entry%.*}..."

          install_src "$src" "${dst%.*}"
        else
          echo "$entry -> $dst"
          ln -sf "$src" "$dst"
        fi
      fi

    else
      mkdir -p "$dst"
    fi
  done

  echo ""
}


install_pkg() {
  local module="$1"
  local file="$SCRIPT_DIR/$module/$PKGFILE"

  if [[ -f "$file" ]] && [[ ! -z $(cat "$file") ]]; then
    if type $PKGMGR &> /dev/null; then
      echo "Install Packages..."
      echo ""

      # preprocess
      local pkgs=()
      while read line; do
        if [[ ! "$line" =~ ^#.* ]] && [[ ! -z "$line" ]]; then
          pkgs+=("$line")
        fi
      done < "$file"

      $PKGMGR "${PKGMGR_ARG[@]}" "${pkgs[@]}"
      echo ""
    else
      echo "Warn: package manager $PKGMGR not found."
      echo ""
    fi
  fi
}


print_help() {
  echo "Usage: ${0##*/} [-h] [-p] [MODULES]"
  echo "Option:"
  echo "  -h    Print print help"
  echo "  -p    Install package written in $PKGFILE"
  exit
}


main() {
  local pkg_flag=0

  if [[ $# == 0 ]]; then
    print_help
    exit
  fi

  while getopts hp OPT; do
    case $OPT in
      h) print_help
         ;;
      p) pkg_flag=1
         ;;
      \?) exit 1
         ;;
    esac
  done
  
  shift $(($OPTIND - 1))


  modules=("$@")

  for module in "${modules[@]}"; do
    install_module "$module"

    if [[ $pkg_flag == 1 ]]; then
      install_pkg "$module"
    fi
  done
}

main "$@"

