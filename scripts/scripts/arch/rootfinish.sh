#! /bin/bash
############################################################################################################
############################   BTRFS SNAPSHOT   ############################################################
############################################################################################################
# sleep 50
# snapper -c root create-config /
# btrfs subvolume delete /.snapshots
# mkdir /.snapshots
# mount -a
# chmod 750 /.snapshots
# chown :everith /.snapshots
# sed -i 's/ALLOW_USERS=""/ALLOW_USERS="everith"/' /etc/snapper/configs/root
# sed -i 's/TIMELINE_LIMIT_HOURLY="10"/TIMELINE_LIMIT_HOURLY="5"/' /etc/snapper/configs/root
# sed -i 's/TIMELINE_LIMIT_DAILY="10"/TIMELINE_LIMIT_DAILY="7"/' /etc/snapper/configs/root
# sed -i 's/TIMELINE_LIMIT_WEEKLY="0"/TIMELINE_LIMIT_WEEKLY="0"/' /etc/snapper/configs/root
# sed -i 's/TIMELINE_LIMIT_MONTHLY="10"/TIMELINE_LIMIT_MONTHLY="0"/' /etc/snapper/configs/root
# sed -i 's/TIMELINE_LIMIT_YEARLY="10"/TIMELINE_LIMIT_YEARLY="0"/' /etc/snapper/configs/root

############################################################################################################
###############################   BACKUP HOOK   ############################################################
############################################################################################################
# mkdir /etc/pacman.d/hooks
# echo "[Trigger]" >> /etc/pacman.d/hooks/50-bootbackup.hook
# echo "Operation = Upgrade" >> /etc/pacman.d/hooks/50-bootbackup.hook
# echo "Operation = Install" >> /etc/pacman.d/hooks/50-bootbackup.hook
# echo "Operation = Remove" >> /etc/pacman.d/hooks/50-bootbackup.hook
# echo "Type = Path" >> /etc/pacman.d/hooks/50-bootbackup.hook
# echo "Target = boot/*" >> /etc/pacman.d/hooks/50-bootbackup.hook
# echo "" >> /etc/pacman.d/hooks/50-bootbackup.hook
# echo "[Action]" >> /etc/pacman.d/hooks/50-bootbackup.hook
# echo "Depends = rsync" >> /etc/pacman.d/hooks/50-bootbackup.hook
# echo "Description = Backup boot files" >> /etc/pacman.d/hooks/50-bootbackup.hook
# echo "When = PreTransaction" >> /etc/pacman.d/hooks/50-bootbackup.hook
# echo "Exec = /usr/bin/rsync -a --delete /boot /.bootbackup" >> /etc/pacman.d/hooks/50-bootbackup.hook

############################################################################################################
#####################################   fstab   ############################################################
############################################################################################################
#network location example:
# //192.168.1.100/Downloads  /Server cifs    credentials=/root/servercreds,uid=1000,iocharset=utf8,vers=2.0  0   0
# Behemoth servers
mkdir -p /server/dev
mkdir -p /server/server
mkdir -p /server/media
mkdir -p /server/novels
mkdir -p /server/games
echo "//behemoth.local/dev    	/server/dev        cifs            credentials=/root/servercreds,uid=1000,iocharset=utf8,file_mode=0777,dir_mode=0777,vers=2.0,rw	0 0" >> /etc/fstab
echo "//behemoth.local/server 	/server/server     cifs            credentials=/root/servercreds,uid=1000,iocharset=utf8,file_mode=0777,dir_mode=0777,vers=2.0,rw	0 0" >> /etc/fstab
echo "//behemoth.local/media  	/server/media      cifs            credentials=/root/servercreds,uid=1000,iocharset=utf8,file_mode=0777,dir_mode=0777,vers=2.0,rw	0 0" >> /etc/fstab
echo "//behemoth.local/novels 	/server/novels     cifs            credentials=/root/servercreds,uid=1000,iocharset=utf8,file_mode=0777,dir_mode=0777,vers=2.0,rw	0 0" >> /etc/fstab
echo "//behemoth.local/games  	/server/games      cifs            credentials=/root/servercreds,uid=1000,iocharset=utf8,file_mode=0777,dir_mode=0777,vers=2.0,rw	0 0" >> /etc/fstab


############################################################################################################
############################   ENABLE SERVICES   ###########################################################
############################################################################################################
systemctl enable NetworkManager
#systemctl enable bluetooth
#systemctl enable cups.service
systemctl enable sshd
#systemctl enable avahi-daemon
#systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
#systemctl enable reflector.timer
#systemctl enable fstrim.timer
#systemctl enable libvirtd
#systemctl enable firewalld
#systemctl enable acpid

############################################################################################################
############################################################################################################
# Remove no password sudo rights from wheel group
#sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
# Add sudo rights to wheel group
#sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

#TODO lvm2 and btrfs version
# LVM2
#sed -i 's/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev autodetect modconf block lvm2 filesystems keyboard fsck)/' /etc/mkinitcpio.conf 
# BTRFS
#sed -i 's/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev autodetect modconf block filesystems keyboard)/' /etc/mkinitcpio.conf 
#sed -i 's/MODULES=()/MODULES=(btrfs)/' /etc/mkinitcpio.conf 
echo "###########################"
echo "### Stage 3 ...       #####"
echo "###########################"

mkinitcpio -P           #recreate all kernel modules
#mkinitcpio -p linux    #recreate linux kernel modules

chown -R $EVEUSER:$EVEUSER /home/$EVEUSER
echo "###########################"
echo "### Stage 3 completed #####"
echo "###########################"