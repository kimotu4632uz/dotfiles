#!/bin/bash -e

sudo groupadd -f uinput
sudo gpasswd -a $USER uinput
sudo gpasswd -a $USER input

if [ ! -f /etc/modules-load.d/uinput.conf ]; then
sudo tee /etc/modules-load.d/uinput.conf <<EOF >/dev/null
uinput
EOF
fi

if [ ! -f /etc/udev/rules.d/70-uinput.rules ]; then
sudo tee /etc/udev/rules.d/70-uinput.rules <<EOF >/dev/null
SUBSYSTEM=="misc", KERNEL=="uinput", MODE="0660", GROUP="uinput"
EOF
fi

systemctl --user enable xkeysnail

echo "Please reboot to enable xkeysnail."

