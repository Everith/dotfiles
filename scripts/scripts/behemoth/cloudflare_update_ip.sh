#!/usr/bin/env bash
zone=szepezdi.hu
dnsrecord=szepezdi.hu
dnsrecord2=*.szepezdi.hu
CLOUDFLARE_API_TOKEN=CboXDw_eU0wKoWDozwuyRk6v4goEDLsGZjCgJi8V
ZONE_ID=b1741b6b52623612295fd7eaec03210d
DNS_RECORD_ID=f0e57d284558dd6b7dd4d9f0bc6a0c0c
DNS_RECORD_ID2=e7c905e5c8c2af38585899220c3643de



# Get the current external IP address
ip=$(curl -s -X GET https://checkip.amazonaws.com)

echo "Current IP is $ip"

# Update szepezdi.hu
if host $dnsrecord 1.1.1.1 | grep "$ip"; then
  echo "$dnsrecord is currently set to $ip; no changes needed"
else
  echo "Updating $dnsrecord to $ip"
  curl https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_RECORD_ID \
    -X PUT \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    --data "{\"type\":\"A\",\"name\":\"$dnsrecord\",\"content\":\"$ip\",\"ttl\":300,\"proxied\":false}" | jq

fi

# Update *.szepezdi.hu
if host $dnsrecord2 1.1.1.1 | grep "$ip"; then
  echo "$dnsrecord2 is currently set to $ip; no changes needed"
else
  echo "Updating $dnsrecord to $ip"
  curl https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_RECORD_ID2 \
    -X PUT \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    --data "{\"type\":\"A\",\"name\":\"$dnsrecord2\",\"content\":\"$ip\",\"ttl\":300,\"proxied\":false}" | jq

fi
