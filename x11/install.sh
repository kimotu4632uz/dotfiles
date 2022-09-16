#!/bin/bash

SCRIPT_DIR="$(cd ${0%/*}; pwd)"

if [[ "$1" == "i3" ]]; then
  ln -s "$SCRIPT_DIR/x11/Xmodmap" "$HOME/.Xmodmap"
  sudo cp "$SCRIPT_DIR/x11/10-touchpad.conf" /etc/X11/xorg.conf.d/

elif [[ "$1" == "sway" ]]; then
  ln -s "$SCRIPT_DIR/x11/jp106_custom" "$HOME/.xkb/symbols/jp106_custom"
fi
