#!/bin/bash

nowplaying_print() {
  playerctl -F metadata --format "{{ status }}:{{ artist }} - {{ title }}" | while read line; do
    echo "$line" | sed -e 's/^Playing:/  /' -e 's/^Paused:/  /'
  done
}

nowplaying_toggle() {
  playerctl play-pause
}

case "$1" in
  --toggle)
    nowplaying_toggle
    ;;
  *)
    nowplaying_print
    ;;
esac

