#!/bin/bash

#echo "Starting port forwarding to server"
#/home/erik/scripts/firewall-deb.sh

echo "Stopping media server"
cd /docker-home/compose/media-server/
docker-compose down
echo "Stoppong home assistant server"
cd /docker-home/compose/home-server/
docker-compose down
cd

echo "UnMounting samba shares"
echo "CCTV"
umount /srv/data/cctv
echo "MEDIA"
umount /srv/data/media/media
echo "SERVER"
umount /srv/data/csalad

