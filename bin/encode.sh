#!/bin/bash
set -e
set -o pipefail

cleanup() {
  cd "$HOME"
  rm -rf "$tmpdir"
}

err_handle() {
  local status=$?
  echo "[$BASH_SOURCE:$LINENO] - "$BASH_COMMAND" returns status $status"
  cleanup
  exit $status
}

sig_handle() {
  echo "Aborting..."
  cleanup
  exit 1
}

print_help() {
  echo "Usage: ${0##*/} [OPTIONS]"
  echo ""
  echo "OPTIONS:"
  echo "  -o, --output <OUTDIR>  Place files to OUTDIR"
}

check_depends() {
  type abcde &> /dev/null || { echo "Error: abcde is not in your PATH"; exit 1; }
  type cd-discid.py &> /dev/null || { echo "Error: cd-discid.py is not in your PATH"; exit 1; }
}

main() {
  local outdir="$HOME"

  while getopts o:h OPT; do
    case $OPT in
      o)
        outdir="${OPTARG%/}"
        ;;

      h)
        print_help
        exit 0
        ;;

      \?)
        exit 1
        ;;
    esac
  done

  trap sig_handle SIGINT
  trap err_handle ERR

  check_depends

  local tmpdir id

  tmpdir=$(mktemp -d)
  cd "$tmpdir"
  
  id=$(cd-discid.py -i)
  cd-discid.py > "$outdir"/"${id}.meta.txt"

  echo "OUTPUTFORMAT='${id}_"'${TRACKNUM}'\' > id.abcde.conf
  abcde -o "flac:-8" -c "$PWD/id.abcde.conf"

  for file in $(find . -maxdepth 1 -mindepth 1 -name "*.flac"); do
    mv "$file" "$outdir/"
  done

  cleanup
}

main "$@"
