#!/bin/bash

restore_root="/srv/backup/temp/srv/backup/temp"

mkdir -p /srv/backup/temp
tar zxf /srv/backup/latest.tar.gz -C /srv/backup/temp


# Install applications: 
apt update && apt upgrade -y
apt install nginx samba git docker docker-compose wireguard tmux transmission-daemon curl wget -y

# Cockpit install 
#
# apt install cockpit cockpit-storaged cockpit-networkmanager 
# cd /tmp
# curl -LO https://github.com/45Drives/cockpit-identities/releases/download/v0.1.12/cockpit-identities_0.1.12-1focal_all.deb
# apt install ./cockpit-identities_0.1.12-1focal_all.deb
# rm cockpit-identities_0.1.12-1focal_all.deb
# cd 

# Install youtube-dl
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
chmod a+rx /usr/local/bin/yt-dlp  # Make executable

chown -R erik:erik /srv

cp -r $restore_root/etc/* /etc/
cp -r $restore_root/srv/* /srv/
cp -r $restore_root/var/* /var/

rm -r /srv/backup/temp
