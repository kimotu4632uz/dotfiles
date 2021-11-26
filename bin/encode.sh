#!/bin/bash
set -e
set -o pipefail

cleanup() {
#  cd "$HOME"
#  rm -rf "$tmpdir"
  :
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
  [[ "$USERPROFILE" == "" ]] && { echo "Error: env \$USERPROFILE is not set"; exit 1; }
  type cd-paranoia.exe &> /dev/null || { echo "Error: cd-paranoia.exe is not in your PATH"; exit 1; }
  type discid.sh &> /dev/null || { echo "Error: discid.sh is not in your PATH"; exit 1; }
}

main() {
  local outdir="$USERPROFILE"/Music

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

  local tmpdir id count

#  tmpdir=$(mktemp -d)
#  cd "$tmpdir"
  
  cd "$outdir"

  cd-paranoia.exe -B

  id=$(discid.sh -i)
  discid.sh > "$outdir"/"${id}.meta.txt"

  count=$(find . -maxdepth 1 -mindepth 1 -name "track*.cdda.wav" | wc -l)

  for iz in $(seq -f "%02g" "$count"); do
    flac -f -8 -o "$outdir"/"${id}_${iz}.flac" "track${iz}.cdda.wav"
    rm "track${iz}.cdda.wav"
  done

  cleanup
}

main "$@"
