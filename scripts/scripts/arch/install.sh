#!/bin/bash

source /root/env.conf
echo "SSID: $SSID"
echo "WIFIPASS: $WIFIPASS"
echo "USER: $USER"
echo "USERPASS: $USERPASS"
echo "ROOTPASS: $ROOTPASS"
echo "END"
sleep 10


bash prepareenviroment.sh
cp ./limine-config/* /mnt/boot/
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
cp servercreds /mnt/root/servercreds
ls -la /mnt/root/
ls -la /mnt/etc/pacman.d
ls -la /mnt/boot/
sleep 10

cp -r .ssh /mnt/root/
cp ./rootsettings.sh /mnt/root/
ls -la /mnt/root/.ssh
ls -la /mnt/root/
sleep 10
arch-chroot /mnt bash /root/rootsettings.sh


cp -r .ssh /mnt/home/$USER/
cp ./usersettings.sh /mnt/home/$USER/usersettings.sh
arch-chroot /mnt /usr/bin/runuser -u $USER -- bash /home/$USER/usersettings.sh

cp ./rootfinish.sh /mnt/root/
arch-chroot /mnt bash /root/rootfinish.sh

echo "#############################"
echo "# Installation is completed #"
echo "#############################"
# reboot