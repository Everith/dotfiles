#!/bin/bash

sudo systemctl stop minecraft@csek.service
cd /srv/minecraft/csek
sudo su minecraft
cp server.properties server.properties.back


wget https://minecraft.azureedge.net/bin-linux/bedrock-server-1.20.80.05.zip -O bedrock-server.zip
unzip bedrock-server.zip
rm temp.zip
cp server.properties.back server.properties


sudo systemctl start minecraft@csek.service
sudo systemctl status minecraft@csek.service
