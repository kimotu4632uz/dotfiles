#!/bin/bash
set -e
set -o pipefail

err_handle() {
  local status=$?
  echo "[$BASH_SOURCE:$LINENO] - "$BASH_COMMAND" returns status $status"
  exit $status
}

sig_handle() {
  echo "Aborting..."
  exit 1
}

print_help() {
  echo "Usage: ${0##*/} [OPTIONS]"
  echo ""
  echo "OPTIONS:"
  echo "  -i, --id  print only FreedbID"
}

check_depends() {
  type discid.exe &> /dev/null || { echo "discid.exe is not in your PATH"; exit 1; }
}

main() {
  local idonly=false

  while getopts ih OPT; do
    case $OPT in
      i)
        idonly=true
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

  local ids=$(discid.exe | sed -e 's/\r//g')

  local id_lower=$(echo "$ids" | grep -E '^FreeDB DiscID.*' | awk '{print $NF}')
  local id=${id_lower^^}

  if $idonly; then
    echo "$id"
    exit 0
  fi

  local mbid=$(echo "$ids" | grep -E '^DiscID.*' | awk '{print $NF}')
  local toc=$(echo "$ids" | sed -e '1,2d' -e '$d ' | awk -F ':' '{print $2}' | awk -v 'ORS= ' '{print $1}')

  local isrc=$(discisrc.exe | sed -e 's/\r//g' | grep "Track" | awk '{printf "ISRC of track %d: %s\n", NR, $NF}')

  echo "MusicBraiz disc id: $mbid"
  echo "FreeDB disc id:     $id"
  echo "$isrc"
  echo "TOC: $toc"
}

main "$@"

