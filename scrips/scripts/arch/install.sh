#!/bin/bash

bash prepareenviroment.sh
arch-chroot /mnt bash /root/rootsettings.sh
source /mnt/root/user.conf
arch-chroot /mnt /usr/bin/runuser -u $username -- bash /home/$username/usersettings.sh
arch-chroot /mnt bash /root/rootfinish.sh

echo "#############################"
echo "# Installation is completed #"
echo "#############################"
#reboot

cat /mnt/etc/fstab
echo "###"
cat /mnt/boot/limine.cfg
