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
NEW_HOSTNAME="myhostname";

CONTAINERD="containerd.io_1.4.3-1_arm64.deb";
DOCKER_BASE_URL="https://download.docker.com/linux/debian/dists/stretch/pool/stable/arm64";
DOCKER_CLI="docker-ce-cli_19.03.9~3-0~debian-stretch_arm64.deb";
DOCKER_CE="docker-ce_19.03.9~3-0~debian-stretch_arm64.deb";

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

if [[ "${NEEDS_REBOOT}" == "true" ]]; then
  reboot;
fi;
```

6) Format SD card, mount on boot to /data (optional)

```
# find disk id via lsblk
SSD_ID="mmcblk1"
SSD_LABEL="homeserverdata"

parted /dev/${SSD_ID} mklabel gpt
parted -a opt /dev/${SSD_ID} mkpart primary ext4 0% 100%

# fetch partition device from blkid eg "/dev/mmcblk1p1"
SSD_DEVICE="/dev/${SSD_ID}p1"
mkfs.ext4 -L homeserverdata "${SSD_DEVICE}"

# get UUID (not PARTUUID) from blkid | grep "${SSD_LABEL}"
SSD_UUID="myuuid"
if ! grep "/data" /etc/fstab; then
  mkdir /data
  echo "UUID=${SSD_UUID} /data ext4 defaults 0 2" >> /etc/fstab
  mount -a
fi;
```

7) Enable wifi

```
WIFI_SSID="mynetworkname"
WIFI_PASS="password"
# wlxsomething
WIFI_DEVICE=$(cat /proc/net/wireless | grep ^w | awk '{print $1}' | rev | cut -c2- | rev)

if ! grep "${WIFI_DEVICE}" /etc/network/interfaces ; then   
  cat << EOF >> /etc/network/interfaces
auto ${WIFI_DEVICE}
allow-hotplug ${WIFI_DEVICE}
iface ${WIFI_DEVICE} inet dhcp
        wpa-ssid ${WIFI_SSID}
        wpa-psk ${WIFI_PASS}
EOF
fi;
ip link set ${WIFI_DEVICE} up
ifup ${WIFI_DEVICE}


```

8) Set a reserved ip address for board in router

9) If pihole enabled visit http://pihole/admin/dns_records.php and set a dns entry for board

10) Add entry to monitor/prometheus-config/homeserver-targets
