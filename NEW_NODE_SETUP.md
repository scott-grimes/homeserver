# New Rock64 Node

Rock64 releases can be found at https://wiki.pine64.org/wiki/ROCK64_Software_Releases

Download image [stretch-minimal-rock64-0.9.14] from Ayufan's github https://github.com/ayufan-rock64/linux-build/releases , [Direct Link](https://github.com/ayufan-rock64/linux-build/releases/download/0.9.14/stretch-minimal-rock64-0.9.14-1159-arm64.img.xz)

1) Snippet will download and validate above image
```
GOODSHA="ee91621563486b2598d7fa45d1bd4f125a12d35effd84940550bfc1551560cdd"
wget -c https://github.com/ayufan-rock64/linux-build/releases/download/0.9.14/stretch-minimal-rock64-0.9.14-1159-arm64.img.xz && \
  FOUNDSHA="$(sha256sum stretch-minimal-rock64-0.9.14-1159-arm64.img.xz | head -c 64)" &&
  if [[ "${FOUNDSHA}" != "${GOODSHA}" ]]; then
    echo "found bad sha ${FOUNDSHA}";
    rm stretch-minimal-rock64-0.9.14-1159-arm64.img.xz;
  else
    echo "found correct sha ${FOUNDSHA}";
  fi;
```

2) Flash the image on each of the eMMC modules using [Etcher](https://www.balena.io/etcher/), install module and empty SD card onto board. Hook up power and ethernet.

3) SSH using default user/password `rock64:rock64`

4) Set new password using `sudo passwd rock64`

5) Modify NEW_HOSTNAME in following snippet, run as root

```
NEW_HOSTNAME="something";
WIFI_SSID="something"
WIFI_PASS="password"

CONTAINERD="containerd.io_1.4.3-1_arm64.deb";
DOCKER_BASE_URL="https://download.docker.com/linux/debian/dists/stretch/pool/stable/arm64";
DOCKER_CLI="docker-ce-cli_19.03.9~3-0~debian-stretch_arm64.deb";
DOCKER_CE="docker-ce_19.03.9~3-0~debian-stretch_arm64.deb";

# WIFI CONFIG
if [[ ! -f /etc/wpa_supplicant/wpa_supplicant.conf ]]; then
    wpa_passphrase "${WIFI_SSID}" "${WIFI_PASS}" > /etc/wpa_supplicant/wpa_supplicant.conf;
fi;

if ! grep "wlan0" /etc/network/interfaces ; then   
  cat << EOF >> /etc/network/interfaces
auto wlan0
iface wlan0 inet dhcp
  wpa-ssid ${WIFI_SSID}
  wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
EOF
fi;

NEEDS_REBOOT=false
if [[ "$(hostname)" != "${NEW_HOSTNAME}" ]]; then
  hostnamectl set-hostname "${NEW_HOSTNAME};"
  NEEDS_REBOOT=true;
fi;
if ! grep -q "${NEW_HOSTNAME}" /etc/hosts ; then
  echo "127.0.0.1 ${NEW_HOSTNAME}" >> /etc/hosts;
  NEEDS_REBOOT=true;
fi;

dpkg -s containerd.io &> /dev/null;
if [[ "$?" == "1" ]]; then
  wget -c "${DOCKER_BASE_URL}/${CONTAINERD}" && dpkg -i ${CONTAINERD};
  rm ${CONTAINERD};
fi;

dpkg -s docker-ce-cli &> /dev/null;
if [[ "$?" == "1" ]]; then
  wget -c "${DOCKER_BASE_URL}/${DOCKER_CLI}" && dpkg -i ${DOCKER_CLI};
  rm ${DOCKER_CLI};
fi;

dpkg -s docker-ce &> /dev/null;
if [[ "$?" == "1" ]]; then
  wget -c "${DOCKER_BASE_URL}/${DOCKER_CE}" && dpkg -i ${DOCKER_CE};
  rm ${DOCKER_CE};
fi;

if ! apt -qq list docker-compose 2> /dev/null | grep -q installed ; then
  apt install -y docker-compose
fi;

systemctl enable docker.service
systemctl enable containerd.service

mkdir -p /data

if [[ "${NEEDS_REBOOT}" == "true" ]]; then
  reboot;
fi;
```

6) Format SD card (optional)





7) Set a reserved ip address for board in router

8) If pihole enabled visit http://pihole/admin/dns_records.php and set a dns entry for board

9) Add entry to monitor/prometheus-config/homeserver-targets
