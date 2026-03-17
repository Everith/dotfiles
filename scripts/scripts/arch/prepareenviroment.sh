#! /bin/bash

############################################################################################################
########################   ARCH ISO      ###################################################################
############################################################################################################

set -e # stop script on error
timedatectl set-ntp true
loadkeys uk
setfont ter-132b

pacman -Sy
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
  echo n;
  echo ;
  echo ;
  echo ;
  echo ;
  echo t;
  echo 2;
  echo 8e;
  echo w;
) | fdisk /dev/sda

# Format the partitions
mkfs.fat -F32 /dev/sda1
mkfs.ext4 -L root -F /dev/sda2

mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# base linux linux-firmeware needed for arch install bare-bone 
pacstrap /mnt base base-devel linux linux-firmware neovim pacman-contrib curl reflector archlinux-keyring --noconfirm
genfstab -U /mnt >> /mnt/etc/fstab


echo "###########################"
echo "### Stage 0 completed #####"
echo "###########################"