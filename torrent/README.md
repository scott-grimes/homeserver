# README

1) Create /data/login.conf file with format
```
vpn-username
vpn-password
```

2) Take note of the `dev` option (eg `tun`) in config.ovpn for step 5

3) Make sure line `auth-user-pass /config/login.conf` exists in config.ovpn so creds are loaded from the file and not stdin

4) Assume root, copy all files file to `/data` then

```
docker-compose up -d
```

5) Login to qbittorrent via the web portal, configure network interface (eg `tun0`) to use only the network interfaced from step 3
