#!/bin/bash

if [[ "$1" == "i3" ]]; then
  ln -s Xmodmap ~/.Xmodmap
  sudo cp 10-touchpad.conf /etc/X11/xorg.conf.d/

elif [[ "$1" == "sway" ]]; then
  ln -s jp106_custom ~/.xkb/symbols/jp106_custom
fi
