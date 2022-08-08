#!/bin/bash -e

print_help() {
  echo "usage: $0 [MODULES]"
  exit
}


install_bin() {
  local dir="$1"
  local dst="$HOME/.local/bin"

  mkdir -p "$dst"

  for file in $(find "$dir" -maxdepth 1 -type f -name "*.src"); do
    (
    source "$file"
    curl -o "${file%.*}" "$url"
    chmod +x "${file%.*}"
  
    if [[ "$patch" != "" ]]; then
      patch --backup-if-mismatch -u "${file%.*}" < "${file%/*}/$patch"
    fi
  
    mv "${file%.*}" "$dst/"
    )
  done

  for file in $(find "$dir" -maxdepth 1 -type f -not -name "*.src"); do
    ln -sf "$PWD/$dir/${file##*/}" "$dst/${file##*/}"
  done
}


install_module() {
  local module="$1"

  echo "install module ${module}..."

  for line in $(cd $module && find . -mindepth 1 -maxdepth 1 -type f); do
    local file=${line#*/}
    local src="$module/$file" 
    local dst="$HOME/.$file"

    echo "$src -> $dst"
    ln -sf "$PWD/$src" "$dst"
  done

  if [[ -d "$module/config" ]]; then
    for line in $(cd "$module/config" && find . -mindepth 1); do
      local entry="${line#*/}"
      local src="$module/config/$entry"
      local dst="$HOME/.config/$entry"

      if [[ -f "$src" ]]; then
        echo "$src -> $dst"
        ln -sf "$PWD/$src" "$dst"
      else
        mkdir -p "$dst"
      fi
    done
  fi
 
  if [[ -d "$module/bin" ]]; then
    echo "install binary..."
    install_bin "$module/bin"
  fi

  echo ""
}

main() {
  while getopts h OPT; do
    case $OPT in
      h) print_help
         ;;
      \?) print_help
         ;;
    esac
  done

  modules=("$@")

  for module in "${modules[@]}"; do
    install_module "$module"
  done
}

main "$@"

