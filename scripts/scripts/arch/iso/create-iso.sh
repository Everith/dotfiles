#!/bin/env bash
pacman -S archiso --noconfirm
rm -r /root/iso
mkdir -p /root/iso
cp -r /usr/share/archiso/configs/releng/ /root/iso
cp start.sh /root/iso/releng/airootfs/root/start.sh
echo "git" >> /root/iso/releng/packages.x86_64
echo "neovim" >> /root/iso/releng/packages.x86_64
echo "networkmanager" >> /root/iso/releng/packages.x86_64

read -p "Please enter SSID:" SSID
echo "SSID=$SSID" >> /root/iso/releng/airootfs/root/env.conf

read -p "Please enter WIFIPASS:" WIFIPASS
echo "WIFIPASS=$WIFIPASS" >> /root/iso/releng/airootfs/root/env.conf

read -p "Please enter USER:" EVEUSER
echo "EVEUSER=$EVEUSER" >> /root/iso/releng/airootfs/root/env.conf

read -p "Please enter USERPASS:" EVEUSERPASS
echo "EVEUSERPASS=$EVEUSERPASS" >> /root/iso/releng/airootfs/root/env.conf

read -p "Please enter ROOTPASS:" ROOTPASS
echo "ROOTPASS=$ROOTPASS" >> /root/iso/releng/airootfs/root/env.conf

read -p "Please enter SAMBAUSER:" SAMBAUSER
echo "username=$SAMBAUSER" >> /root/iso/releng/airootfs/root/servercreds
read -p "Please enter SAMBAPASS:" SAMBAPASS
echo "password=$SAMBAPASS" >> /root/iso/releng/airootfs/root/servercreds
#read -p "Please enter SAMBADOMAIN:" SAMBADOMAIN
echo "domain=WORKGROUP" >> /root/iso/releng/airootfs/root/servercreds

cp -r ~/.ssh /root/iso/releng/airootfs/root/

rm -r /tmp/*
#TODO: rename iso to evdev.iso
# rm /home/erik/archlinux-2024.09.01-x86_64.iso
mkarchiso -v -w /tmp -o /server/dev/ /root/iso/releng/
