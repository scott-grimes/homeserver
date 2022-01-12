# README

1) Assume root, copy docker-compose.yaml file to `/data` then

```
mkdir -p /data/etc-dnsmasq.d  /data/etc-pihole
docker-compose up -d
```

2) Visit
`<ip_address>/admin/dns_records.php` and add `pihole <ip_address>`

3) add `pihole` to whitelist so you can visit `http://pihole`
