ffmpeg -f pulse -i "remote.monitor" -ac 2 -acodec pcm_u8 -ar 48000 -f u8 "udp://192.168.1.1:18181"
