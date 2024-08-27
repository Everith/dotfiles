#! /bin/bash

############################################################################################################
########################   ARCH ISO      ###################################################################
############################################################################################################

set -e # stop script on error
timedatectl set-ntp true
loadkeys uk
setfont ter-132b

pacman -Suy --noconfirm
pacman -S --noconfirm pacman-contrib

#REFLECTOR MIRROR LIST UPDATE 
pacman -S --noconfirm reflector rsync
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
iso=$(curl -4 ifconfig.co/country-iso) #ez lényegében iso=HU
reflector -a 48 -c $iso -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist

(
  echo d;
  echo ;
  echo d;
  echo ;
  echo d;
  echo ;
  echo d;
  echo ;
  echo o;
  echo n;
  echo ;
  echo ;
  echo ;
  echo +1G;
  echo y;
  echo n;
  echo ;
  echo ;
  echo ;
  echo ;
  echo y;
  echo t;
  echo 2;
  echo 8e;
  echo w;
) | fdisk /dev/sda

# Format the partitions
mkfs.fat -F32 /dev/sda1
mkfs.ext4 -L root /dev/sda2

mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# Prompt the user for input
# read -p "Automated (a) or manual (b)? " choice
# case "$choice" in
#     a|A)
#       ;;

#     b|B)
#       # lsblk
#       # echo "Enter the drive: (eg.: /dev/sda )"
#       # read DRIVE
#       # # Format the partitions
#       # mkfs.fat -F32 ${DRIVE}1
#       # mkfs.ext4 -L root ${DRIVE}2

#       # # Format the partitions
#       # mkfs.fat -F32 ${DRIVE}1
#       # mkfs.ext4 -L root ${DRIVE}2

#       # mount ${DRIVE}2 /mnt
#       # mkdir /mnt/boot
#       # mount ${DRIVE}1 /mnt/boot
#       ;;

#     *)
#         echo "Invalid choice. Please choose a, b, c, or d."
#         ;;
# esac


# base linux linux-firmeware needed for arch install bare-bone 
pacstrap /mnt base base-devel linux linux-firmware neovim pacman-contrib curl reflector archlinux-keyring --noconfirm
genfstab -U /mnt >> /mnt/etc/fstab

cp ./1.sh /mnt/root/
cp ./2.sh /mnt/root/
cp ./3.sh /mnt/root/
cp ./limine-config/* /mnt/boot/
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist

echo "###########################"
echo "### Stage 0 completed #####"
echo "###########################"