#! /bin/bash

set -e # stop script on error
timedatectl set-ntp true
loadkeys uk

pacman -Sy --noconfirm
pacman -S --noconfirm pacman-contrib

#REFLECTOR MIRROR LIST UPDATE 
pacman -S --noconfirm reflector rsync
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
iso=$(curl -4 ifconfig.co/country-iso) #ez lényegében iso=HU
reflector -a 48 -c $iso -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist

lsblk
echo "Enter the drive: (eg.: /dev/sda )"
read DRIVE
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${DRIVE}
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +1G # 1GB boot parttion
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  t # change type of partition
  2 # select partition number 2
  8e # select LVM type
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF

# Format the partitions
mkfs.fat -F32 ${DRIVE}1
mkfs.ext4 -L root ${DRIVE}2

mount ${DRIVE}2 /mnt
mkdir /mnt/boot
mount ${DRIVE}1 /mnt/boot

# base linux linux-firmeware needed for arch install bare-bone 
pacstrap /mnt base base-devel linux linux-firmware neovim --noconfirm
genfstab -U /mnt >> /mnt/etc/fstab


cp ./1.sh /mnt/root/
cp ./2.sh /mnt/root/
cp ./3.sh /mnt/root/
cp ./limine-config/limine.cfg /mnt/boot/
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist

echo "###########################"
echo "### Stage 0 completed #####"
echo "###########################"