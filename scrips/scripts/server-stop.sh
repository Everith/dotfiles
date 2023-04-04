#!/bin/bash

#echo "Starting port forwarding to server"
#/home/erik/scripts/firewall-deb.sh

echo "Stopping media server"
cd /srv/docker/compose/media-server/
docker-compose down
echo "Stoppong home assistant server"
cd /srv/docker/compose/home-server/
docker-compose down
cd

echo "UnMounting samba shares"
echo "CCTV"
sudo umount /srv/data/cctv
echo "MEDIA"
sudo umount /srv/data/media
echo "SERVER"
sudo umount /srv/data/server

