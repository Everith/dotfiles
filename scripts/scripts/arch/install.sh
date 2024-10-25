#!/bin/bash

source /root/env.conf
echo "SSID: $SSID"
echo "WIFIPASS: $WIFIPASS"
echo "EVEUSER: $EVEUSER"
echo "EVEUSERPASS: $EVEUSERPASS"
echo "ROOTPASS: $ROOTPASS"
echo "END"
pwd
sleep 10


bash prepareenviroment.sh
cp ./limine-config/* /mnt/boot/
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
cp /root/servercreds /mnt/root

cp -r /root/.ssh /mnt/root/
cp ./rootsettings.sh /mnt/root/
arch-chroot /mnt bash /root/rootsettings.sh
echo "END"
echo "END"
echo "END"
sleep 30

cp -r .ssh /mnt/home/$EVEUSER/
cp ./usersettings.sh /mnt/home/$EVEUSER/usersettings.sh
arch-chroot /mnt /usr/bin/runuser -u $EVEUSER -- bash /home/$EVEUSER/usersettings.sh

cp ./rootfinish.sh /mnt/root/
arch-chroot /mnt bash /root/rootfinish.sh

echo "#############################"
echo "# Installation is completed #"
echo "#############################"
# reboot