#!/bin/bash

#make backup folder to home

date=$(date '+%Y-%m-%d')

docker_home="srv/docker"
backup_temp="/srv/backup/temp"
backup="/srv/backup"
#
# mkdir ~/.backup/$date
# mkdir /srv/backup/$date
#

# Docker VMs
mkdir -p $backup_temp
mkdir -p $backup_temp/$docker_home
cp -r /$docker_home/compose $backup_temp/$docker_home
cp -r /$docker_home/homeassistant $backup_temp/$docker_home
cp -r /$docker_home/pihole $backup_temp/$docker_home
cp -r /$docker_home/mosquitto-data $backup_temp/$docker_home
cp -r /$docker_home/zigbee2mqtt-data $backup_temp/$docker_home


mkdir -p $backup_temp/$docker_home/jellyfin/config
cp -r /$docker_home/jellyfin/config/config $backup_temp/$docker_home/jellyfin/config
cp -r /$docker_home/jellyfin/config/log $backup_temp/$docker_home/jellyfin/config
cp -r /$docker_home/jellyfin/config/data $backup_temp/$docker_home/jellyfin/config
cp -r /$docker_home/jellyfin/config/root $backup_temp/$docker_home/jellyfin/config
cp -r /$docker_home/jellyfin/config/plugins $backup_temp/$docker_home/jellyfin/config
cp -r /$docker_home/jellyfin/config/metadata $backup_temp/$docker_home/jellyfin/config

cp -r /$docker_home/universalmediaserver $backup_temp/$docker_home

cp -r /$docker_home/prowlarr $backup_temp/$docker_home
cp -r /$docker_home/radarr $backup_temp/$docker_home
cp -r /$docker_home/sonarr $backup_temp/$docker_home
cp -r /$docker_home/bazarr $backup_temp/$docker_home
cp -r /$docker_home/lidarr $backup_temp/$docker_home
cp -r /$docker_home/readarr $backup_temp/$docker_home

# System config files
mkdir -p $backup_temp/etc/nginx/sites-enabled
cp -r /etc/nginx/sites-available $backup_temp/etc/nginx
cp /etc/nginx/nginx.conf $backup_temp/etc/nginx
mkdir -p $backup_temp/var/www
cp -r /srv/www/* $backup_temp/var/www

mkdir -p $backup_temp/etc/samba
cp -r /etc/samba/smb.conf $backup_temp/etc/samba

mkdir -p $backup_temp/etc/wireguard
cp -r /etc/wireguard/* $backup_temp/etc/wireguard

mkdir -p $backup_temp/etc/transmission-daemon
cp -r /etc/transmission-daemon/* $backup_temp/etc/transmission-daemon
cp -r /var/lib/transmission-daemon/* $backup_temp/etc/transmission-daemon

mkdir -p $backup_temp/etc/systemd/system
cp /etc/systemd/system/* $backup_temp/etc/systemd/system

cp /etc/motd $backup_temp/etc
cp -r /var/spool/cron/crontabs/* $backup_temp/var/spool/cron/crontabs


#DUCKDNS
cp -r /home/erik/duckdns/* $backup_temp/home/erik/duckdns

# notes
cp -r /etc/fstab $backup_temp/etc
sudo apt list | awk -F'/' '{ printf "%-30s %s\n", $1, $2 }' > $backup_temp/installed_application.txt


mv $backup/latest.tar.gz $backup/$date.tar
tar zcf $backup/latest.tar.gz $backup_temp/*

rm -r $backup_temp
