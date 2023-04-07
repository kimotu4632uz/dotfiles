#!/bin/bash

sudo gpasswd -a $USER input
libinput-gestures-setup
libinput-gestures-setup autostart
libinput-gestures-setup start

sudo systemctl enable tlp
sudo systemctl start tlp

