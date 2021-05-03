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
  echo "Usage: encode.sh [OPTIONS]"
  echo ""
  echo "OPTIONS:"
  echo "  -o, --output <OUTDIR>  Place files to OUTDIR"
}

main() {
  local outdir="$USERPROFILE"/Music

  for OPT in "$@"; do
    case $OPT in
      -h | --help)
        print_help
        exit 0
        ;;

      -o | --output)
        outdir="${2%/}"
        shift 2
        ;;

      -*)
        echo "encode.sh: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
        exit 1
        ;;
    esac
  done

  [[ "$USERPROFILE" == "" ]] && { echo "Error: env \$USERPROFILE is not set"; exit 1; }

  trap sig_handle SIGINT
  trap err_handle ERR

  local tmpdir id count

  tmpdir=$(mktemp -d)
  cd "$tmpdir"

  "$USERPROFILE"/Programs/cd-paranoia.exe -B

  id=$("$USERPROFILE"/Programs/cdio-discid.exe | tr -dc '[:alnum:]')
  count=$(find . -maxdepth 1 -mindepth 1 -name "*.wav" | wc -l)

  for iz in $(seq -f "%02g" "$count"); do
    flac -f -8 -o "$outdir"/"${id}_${iz}.flac" "track${iz}.cdda.wav"
    #opusenc --bitrate 160 "track${iz}.cdda.wav" "$outdir"/"${id}_${iz}.opus"
  done

  cleanup
}

main "$@"
