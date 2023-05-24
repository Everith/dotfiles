#!/bin/bash

#make backup folder to home

date=$(date '+%Y-%m-%d')

docker_home="srv/docker"
#
# mkdir ~/.backup/$date
# mkdir /srv/backup/$date
#

# Docker VMs
mkdir -p /srv/backup/temp
mkdir -p /srv/backup/temp/$docker_home
cp -r /$docker_home/compose /srv/backup/temp/$docker_home
cp -r /$docker_home/homeassistant /srv/backup/temp/$docker_home
cp -r /$docker_home/pihole /srv/backup/temp/$docker_home
cp -r /$docker_home/mosquitto-data /srv/backup/temp/$docker_home

mkdir -p /srv/backup/temp/$docker_home/jellyfin/config
cp -r /$docker_home/jellyfin/config/config /srv/backup/temp/$docker_home/jellyfin/config
cp -r /$docker_home/jellyfin/config/log /srv/backup/temp/$docker_home/jellyfin/config
cp -r /$docker_home/jellyfin/config/data /srv/backup/temp/$docker_home/jellyfin/config
cp -r /$docker_home/jellyfin/config/root /srv/backup/temp/$docker_home/jellyfin/config
cp -r /$docker_home/jellyfin/config/plugins /srv/backup/temp/$docker_home/jellyfin/config
cp -r /$docker_home/jellyfin/config/metadata /srv/backup/temp/$docker_home/jellyfin/config

cp -r /$docker_home/prowlarr /srv/backup/temp/$docker_home
cp -r /$docker_home/radarr /srv/backup/temp/$docker_home
cp -r /$docker_home/sonarr /srv/backup/temp/$docker_home
cp -r /$docker_home/bazarr /srv/backup/temp/$docker_home
cp -r /$docker_home/lidarr /srv/backup/temp/$docker_home
cp -r /$docker_home/readarr /srv/backup/temp/$docker_home


# System config files
mkdir -p /srv/backup/temp/etc/nginx/sites-enabled
cp -r /etc/nginx/sites-available /srv/backup/temp/etc/nginx

mkdir -p /srv/backup/temp/etc/samba
cp -r /etc/samba/smb.conf /srv/backup/temp/etc/samba

cp -r /etc/fstab /srv/backup/temp/etc

sudo apt list | awk -F'/' '{ printf "%-30s %s\n", $1, $2 }' > /srv/backup/temp/installed_application.txt

mkdir -p /srv/backup/temp/etc/systemd/system
cp /etc/systemd/system/minecraft@.service /srv/backup/temp/etc/systemd/system

