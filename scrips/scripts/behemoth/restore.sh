#!/bin/bash

restore_root="/srv/backup/temp/srv/backup/temp"

mkdir -p /srv/backup/temp
tar zxf /srv/backup/latest.tar.gz -C /srv/backup/temp

# Install applications: 
sudo apt update && apt upgrade -y
sudo apt install nginx samba git docker docker-compose wireguard tmux transmission-daemon curl wget exa btop zsh syncthing -y

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

# sudo chown -R erik:erik /srv

sudo systemctl stop nginx
sudo systemctl stop transmission-daemon
sudo systemctl stop smb

sudo cp -r $restore_root/etc/* /etc/
sudo cp -r $restore_root/srv/* /srv/
sudo cp -r $restore_root/var/* /var/
sudo cp -r $restore_root/home/erik/* /home/erik/

sudo systemctl start nginx
sudo systemctl start transmission-daemon
sudo systemctl start smb

sudo rm -r /srv/backup/temp

cd /var/lib/transmission-daemon/
sudo curl -OL https://github.com/johman10/flood-for-transmission/releases/download/latest/flood-for-transmission.zip
sudo unzip flood-for-transmission.zip
sudo rm flood-for-transmission.zip
sudo chown -R erik:debian-transmission /var/lib/transmission-daemon/flood-for-transmission
cd

mkdir /srv/cctv
mkdir /srv/syncthing
sudo addgroup media
sudo addgroup csalad

# sudo useradd --user-group --create-home --groups csalad 
sudo useradd --user-group --system --no-create-home --groups csalad nginx
sudo usermod -aG media,docker,csalad erik
sudo usermod -aG media debian-transmission

#Fixing permissions:
# sudo chown -R erik:media /srv/data
sudo chown -R erik:docker /srv/docker
sudo chown -R erik:media /srv/cctv
sudo chown -R erik:media /srv/syncthing
sudo chown erik:crontab /var/spool/cron/crontabs/erik
