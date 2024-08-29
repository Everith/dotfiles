#!/bin/env bash

iwctl --.phassphrase balazs94 station wlan0 connect Balazs
echo "Connecting to WIFI Balazs ... "
sleep 5

git clone https://github.com/everith/dotfiles.git

cd dotfiles/scripts/scripts/arch
bash install.sh