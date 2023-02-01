#! /bin/bash

echo "Starting port forwarding to server"
/home/erik/scripts/firewall-deb.sh

echo "Mounting samba shares"
echo "CCTV"
mount -t cifs -o username=erik,password=5589654785 //10.122.0.2/cctv /srv/data/cctv
echo "MEDIA"
mount -t cifs -o username=erik,password=5589654785 //10.122.0.2/media /srv/data/media/media
echo "SERVER"
mount -t cifs -o username=erik,password=5589654785 //10.122.0.2/csalad /srv/data/csalad

echo "Starting media server"
cd /docker-home/compose/media-server/
docker-compose up -d
echo "Starting home assistant server"
cd /docker-home/compose/home-server/
docker-compose up -d
cd
