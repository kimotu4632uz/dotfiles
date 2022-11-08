#!/bin/bash

sudo gpasswd -a $USER input

sudo systemctl enable tlp
sudo systemctl start tlp
