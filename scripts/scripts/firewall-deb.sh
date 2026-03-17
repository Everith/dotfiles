#!/bin/bash
echo "Redirecting Cockpit admin page"
iptables -A PREROUTING -t nat -i eno1 -p tcp --dport 9093 -j DNAT --to-destination 192.168.33.2:9090
iptables -A FORWARD -p tcp -d 192.168.33.2 --dport 9093 -j ACCEPT

# jackett Fonyod
echo "Redirecting Jackett"
iptables -A PREROUTING -t nat -i eno1 -p tcp --dport 9117 -j DNAT --to-destination 192.168.33.2:9117
iptables -A FORWARD -p tcp -d 192.168.33.2 --dport 9117 -j ACCEPT
# radarr Fonyod
echo "Redirecting Radarr"
iptables -A PREROUTING -t nat -i eno1 -p tcp --dport 7878 -j DNAT --to-destination 192.168.33.2:7878
iptables -A FORWARD -p tcp -d 192.168.33.2 --dport 7878 -j ACCEPT
# sonarr Fonyod
echo "Redirecting Sonarr"
iptables -A PREROUTING -t nat -i eno1 -p tcp --dport 8989 -j DNAT --to-destination 192.168.33.2:8989
iptables -A FORWARD -p tcp -d 192.168.33.2 --dport 8989 -j ACCEPT
# Torrent Fonyod
echo "Redirecting Torrent"
iptables -A PREROUTING -t nat -i eno1 -p tcp --dport 9091 -j DNAT --to-destination 192.168.33.2:9091
iptables -A FORWARD -p tcp -d 192.168.33.2 --dport 9091 -j ACCEPT

echo "Redirecting Stable Defusion WEBUI"
iptables -A PREROUTING -t nat -i eno1 -p tcp --dport 7860 -j DNAT --to-destination 192.168.33.2:7860
iptables -A FORWARD -p tcp -d 192.168.33.2 --dport 7860 -j ACCEPT

# samba
echo "Redirecting Samba shares"
iptables -A PREROUTING -t nat -i eno1 -p tcp --dport 445 -j DNAT --to-destination 192.168.33.2:445
iptables -A FORWARD -p tcp -d 192.168.33.2 --dport 445 -j ACCEPT
iptables -A PREROUTING -t nat -i eno1 -p tcp --dport 139 -j DNAT --to-destination 192.168.33.2:139
iptables -A FORWARD -p tcp -d 192.168.33.2 --dport 139 -j ACCEPT
iptables -A PREROUTING -t nat -i eno1 -p udp --dport 138 -j DNAT --to-destination 192.168.33.2:138
iptables -A FORWARD -p udp -d 192.168.33.2 --dport 138 -j ACCEPT
iptables -A PREROUTING -t nat -i eno1 -p udp --dport 137 -j DNAT --to-destination 192.168.33.2:137
iptables -A FORWARD -p udp -d 192.168.33.2 --dport 137 -j ACCEPT

echo "Enabel forwarding"
iptables -A POSTROUTING -t nat -s 192.168.33.0 -o wg0 -j MASQUERADE


# Open PiHole tcp port
echo "Opening PiHole port"
iptables -A INPUT -p tcp --dport 8088 -j ACCEPT

