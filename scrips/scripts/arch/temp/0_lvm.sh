#! /bin/bash

set -e # stop script on error
timedatectl set-ntp true
loadkeys uk

pacman -Sy --noconfirm
pacman -S --noconfirm pacman-contrib lvm2

#REFLECTOR MIRROR LIST UPDATE 
pacman -S --noconfirm reflector rsync
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
iso=$(curl -4 ifconfig.co/country-iso) #ez lényegében iso=HU
reflector -a 48 -c $iso -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist

lsblk
LVM_VOLUME_GROUP=vg
LVM_DRIVE=lv_root
LVM_BOOT=lv_boot
echo "Enter the drive: (eg.: /dev/sda )"
read DRIVE
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${DRIVE}
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partion number 1
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  t # change type of partition
  1 # select partition number 1
  8e # select LVM type
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF

# Create the LVM volumes
pvcreate ${DRIVE}1
vgcreate ${LVM_VOLUME_GROUP} ${DRIVE}1
lvcreate -L 1G -n ${LVM_BOOT} ${LVM_VOLUME_GROUP}
lvcreate -L 5G -n lv_snaoshot_placeholder ${LVM_VOLUME_GROUP}
lvcreate -l 100%FREE -n ${LVM_DRIVE} ${LVM_VOLUME_GROUP}

# Format the partitions
mkfs.ext4 -L boot /dev/${LVM_VOLUME_GROUP}/${LVM_BOOT}
mkfs.ext4 -L root /dev/${LVM_VOLUME_GROUP}/${LVM_DRIVE}

mount /dev/${LVM_VOLUME_GROUP}/${LVM_DRIVE} /mnt
mkdir /mnt/boot
mount /dev/${LVM_VOLUME_GROUP}/${LVM_BOOT} /mnt/boot

# base linux linux-firmeware needed for arch install bare-bone 
pacstrap /mnt base base-devel linux linux-firmware wget curl neovim networkmanager dhclient lvm2 --noconfirm
genfstab -U /mnt >> /mnt/etc/fstab
#echo "keyserver hkp://keyserver.ubuntu.com" >> /mnt/etc/pacman.d/gnupg/gpg.conf  #ez miez ?

cp -R ~/dotfiles /mnt/root/
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist