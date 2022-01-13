# README

1) Assume root, copy docker-compose.yaml file to `/data` then

```
mkdir -p /data/etc-dnsmasq.d  /data/etc-pihole
docker-compose up -d
```

2) Edit router to use pihole's fixed ip as dns server
