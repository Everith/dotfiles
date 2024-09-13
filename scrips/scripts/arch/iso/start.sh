#!/bin/env bash

source env.conf

systemctl start NetworkManager
sleep 10

nmcli dev wifi connect $SSID password $WIFIPASS
echo "Connecting to WIFI Balazs ... "
sleep 10

pacman -Su

git clone https://github.com/Everith/dotfiles.git
sleep 10

cd dotfiles/scrips/scripts/arch
bash install.sh
