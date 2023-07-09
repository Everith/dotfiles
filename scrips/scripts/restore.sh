#!/bin/bash

restore_root="/srv/backup/temp/srv/backup/temp"

mkdir -p /srv/backup/temp
tar zxf /srv/backup/latest.tar.gz -C /srv/backup/temp


# Install applications: 
sudo apt update && apt upgrade -y
sudo apt install nginx samba git docker docker-compose wireguard tmux transmission-daemon curl wget exa btop zsh -y

# Cockpit install 
sudo apt install cockpit cockpit-storaged cockpit-networkmanager 
sudo cd /tmp
sudo curl -LO https://github.com/45Drives/cockpit-identities/releases/download/v0.1.12/cockpit-identities_0.1.12-1focal_all.deb
sudo apt install ./cockpit-identities_0.1.12-1focal_all.deb
sudo rm cockpit-identities_0.1.12-1focal_all.deb
sudo cd 

# Install youtube-dl
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp  # Make executable

sudo chown -R erik:erik /srv

sudo cp -r $restore_root/etc/* /etc/
sudo cp -r $restore_root/srv/* /srv/
sudo cp -r $restore_root/var/* /var/

sudo rm -r /srv/backup/temp
