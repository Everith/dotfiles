#!/bin/env bash

source env.conf

nmcli dev wifi connect $SSID password $WIFIPASS
echo "Connecting to WIFI Balazs ... "
sleep 5

git clone --recursive git@github.com:Everith/dotfiles.git

cd dotfiles/scripts/scripts/arch
bash install.sh