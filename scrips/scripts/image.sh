ffmpeg -rtsp_transport tcp -i "rtsp://192.168.0.10:554/user=admin_password=tlJwpbo6_channel=1_stream=0.sdp?real_stream" -frames:v 1 /srv/data/cctv/kert_1.jpg -y
ffmpeg -rtsp_transport tcp -i "rtsp://192.168.0.11:554/user=admin_password=nmv7veN2_channel=1_stream=0.sdp?real_stream" -frames:v 1 /srv/data/cctv/kert_2.jpg -y
