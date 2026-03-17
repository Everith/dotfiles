#!/bin/bash

echo "Starting port forwarding to server"
sudo /home/erik/scripts/firewall-deb.sh

echo "Mounting samba shares"
echo "CCTV"
sudo mount -t cifs -o echo_interval=30,rw,username=erik,password=5589654785,uid=1000 //10.122.0.2/cctv /srv/data/cctv
echo "MEDIA"
sudo mount -t cifs -o echo_interval=30,rw,username=erik,password=5589654785,uid=1000 //10.122.0.2/media /srv/data/media
echo "SERVER" 
sudo mount -t cifs -o echo_interval=30,rw,username=erik,password=5589654785,uid=1000 //10.122.0.2/csalad /srv/data/server

# echo "Mounting samba shares"
# echo "CCTV"
# sudo mount -t cifs -o username=erik,password=5589654785,uid=$(id -u),gid=$(id -g),forceuid,forcegid,file_mode=0775,dir_mode=0775 //10.122.0.2/cctv /srv/data/cctv
# echo "MEDIA"
# sudo mount -t cifs -o username=erik,password=5589654785,uid=$(id -u),gid=$(id -g),forceuid,forcegid,file_mode=0775,dir_mode=0775 //10.122.0.2/media /srv/data/media
# echo "SERVER"
# sudo mount -t cifs -o username=erik,password=5589654785,uid=$(id -u),gid=$(id -g),forceuid,forcegid,file_mode=0775,dir_mode=0775 //10.122.0.2/csalad /srv/data/server

echo "Starting media server"
cd /srv/docker/compose/media-server/
docker-compose up -d
echo "Starting home assistant server"
cd /srv/docker/compose/home-server/
docker-compose up -d
cd
