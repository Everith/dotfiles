#!/bin/bash

bash prepareenviroment.sh
arch-chroot /mnt bash /root/1.sh
source /mnt/root/user.conf
arch-chroot /mnt /usr/bin/runuser -u $username -- bash /home/$username/2.sh
arch-chroot /mnt bash /root/3.sh

echo "#############################"
echo "# Installation is completed #"
echo "#############################"
#reboot

cat /mnt/etc/fstab
echo "###"
cat /mnt/boot/limine.cfg
