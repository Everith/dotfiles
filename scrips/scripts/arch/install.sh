#!/bin/bash

source env.conf

bash prepareenviroment.sh
cp servercreds /mnt/root/servercreds
cp -r .ssh /mnt/root/

arch-chroot /mnt bash /root/rootsettings.sh
arch-chroot /mnt /usr/bin/runuser -u $USER -- bash /home/$USER/usersettings.sh
arch-chroot /mnt bash /root/rootfinish.sh



echo "#############################"
echo "# Installation is completed #"
echo "#############################"
# reboot