#!/bin/bash
mkdir -p ~/.config/fcitx5/skk
yaskkserv2_make_dictionary --dictionary-filename=$HOME/.config/fcitx5/skk/dictionary.yaskkserv2 /usr/share/skk/SKK-JISYO.{L,jinmei,fullname,geo,station,propernoun}
systemctl --user enable yaskkserv2
