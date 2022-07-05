# README

1) Assume root, copy files to `/data`

2) Check the device id of zigbee by running `ls /dev/serial/by-id`.
   Edit docker-compose.yaml file to mount the device

```
mkdir -p homeassistant-config
chown -R rock64:rock64 homassistant-config
```

3) Run `docker-compose up -d`, ignore any errors in logs.
4) Create user and password.
5) Name install name as `Home`, don't fill out anything else. Don't install any integrations.
6) Settings -> System -> Reboot
7) Settings -> Devices and Services
8) Add Integration Meteorologisk integration, name `Home`. Set zone `External`. Enable hourly entity.
9) Install ZHA integration. Do not set zone for coordinator. Add entities with names and zones from zigbee.enc
10) Generate long-lived token by visiting user profile > Long-Lived Access Tokens > create token -> "prom". Store in monitor/prometheus-config/hub_token
