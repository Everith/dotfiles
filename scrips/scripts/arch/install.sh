#!/bin/bash

source env.conf

bash prepareenviroment.sh
cp servercreds /mnt/root/servercreds
cp -r .ssh /mnt/root/
cp -r .ssh /mnt/home/$USER/
cp ./usersettings.sh /mnt/home/$USER/usersettings.sh
cp ./rootfinish.sh /mnt/root/
cp ./rootsettings.sh /mnt/root/
cp ./limine-config/* /mnt/boot/
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist


arch-chroot /mnt bash /root/rootsettings.sh
arch-chroot /mnt /usr/bin/runuser -u $USER -- bash /home/$USER/usersettings.sh
arch-chroot /mnt bash /root/rootfinish.sh



echo "#############################"
echo "# Installation is completed #"
echo "#############################"
# reboot