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
  +300M # 300M boot parttion
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF

# Format the partitions
mkfs.ext4 -L boot /dev/sda1
mkfs.btrfs -L root /dev/sda2

#btrfs create subvolumes
mount /dev/sda2 /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@var_log #prog not needed
umount /mnt

#btrfs options and mounting
mount -o noatime,compress=lzo,space_cache=v2,subvol=@ /dev/sda2 /mnt
mkdir /mnt/{boot,home,.snapshots,var_log}
mount -o noatime,compress=lzo,space_cache=v2,subvol=@home /dev/sda2 /mnt/home
mount -o noatime,compress=lzo,space_cache=v2,subvol=@snapshots /dev/sda2 /mnt/.snapshots
mount -o noatime,compress=lzo,space_cache=v2,subvol=@var_log /dev/sda2 /mnt/var_log
mount /dev/sda1 /mnt/boot

# base linux linux-firmeware needed for arch install bare-bone 
pacstrap /mnt base base-devel linux linux-firmware neovim networkmanager dhclient --noconfirm
genfstab -U /mnt >> /mnt/etc/fstab


cp -R ~/dotfiles /mnt/root/
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist