#!/bin/bash

#bash 0_btrfs.sh
bash 0.sh
arch-chroot /mnt bash /root/dotfiles/1.sh
source /mnt/root/user.conf
arch-chroot /mnt /usr/bin/runuser -u $username -- bash /home/$username/dotfiles/2.sh
#umount /mnt/.snapshots
#rm -r /mnt/.snapshots
arch-chroot /mnt bash /root/dotfiles/3.sh

echo "#############################"
echo "# Installation is completed #"
echo "#############################"
#reboot