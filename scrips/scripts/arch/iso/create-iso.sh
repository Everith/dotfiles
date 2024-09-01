#!/bin/env bash

mkdir -p iso/profile
cp -r /usr/share/archiso/configs/releng/ iso/profile
cp packages.x86_64 /root/iso/profile/releng/packages.x86_64


read -p "Please enter SSID:" SSID
echo "SSID=$SSID" >> /root/iso/profile/releng/airootfs/root/env.conf

read -p "Please enter WIFIPASS:" WIFIPASS
echo "WIFIPASS=$WIFIPASS" >> /root/iso/profile/releng/airootfs/root/env.conf

read -p "Please enter USER:" USER
echo "USER=$USER" >> /root/iso/profile/releng/airootfs/root/env.conf

read -p "Please enter USERPASS:" USERPASS
echo "USERPASS=$USERPASS" >> /root/iso/profile/releng/airootfs/root/env.conf

read -p "Please enter ROOTPASS:" ROOTPASS
echo "ROOTPASS=$ROOTPASS" >> /root/iso/profile/releng/airootfs/root/env.conf

cp -r /home/erik.ssh /root/iso/profile/releng/airootfs/root/


rm -r /root/iso/build/
#TODO: rename iso to evdev.iso
# rm /home/erik/archlinux-2024.09.01-x86_64.iso
mkarchiso -v -w /root/iso/build/ -o /home/erik/ /root/iso/profile/releng/
