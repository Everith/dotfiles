#!/bin/bash

mkdir -p /srv/backup/temp
tar zxf /srv/backup/latest.tar.gz -C /srv/backup/temp


# Install applications: 

# Install youtube-dl
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp  # Make executable
