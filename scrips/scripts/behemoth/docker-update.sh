#!/bin/bash
#
cd /srv/docker/compose/home-server
docker-compose down
docker-compose pull
docker-compose up -d


cd /srv/docker/compose/media-server
docker-compose down
docker-compose pull
docker-compose up -d

