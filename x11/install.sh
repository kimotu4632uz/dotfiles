#!/bin/bash

SCRIPT_DIR="$(cd ${0%/*}; pwd)"

if [[ "$1" == "i3" ]]; then
  ln -s "$SCRIPT_DIR/Xmodmap" "$HOME/.Xmodmap"
  sudo cp "$SCRIPT_DIR/10-touchpad.conf" /etc/X11/xorg.conf.d/

elif [[ "$1" == "sway" ]]; then
  ln -s "$SCRIPT_DIR/jp106_custom" "$HOME/.xkb/symbols/jp106_custom"
fi
