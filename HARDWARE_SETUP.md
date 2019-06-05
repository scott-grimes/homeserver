# Kubernetes on Rock64 From Scratch

1) Flash the image on each of the eMMC modules using [Etcher](https://www.balena.io/etcher/), install module and empty SD card onto board. Hook up power and ethernet.

The current image used is Ayufan's [bionic-minimal-rock64-0.7.9](https://github.com/ayufan-rock64/linux-build/releases) SHA256-cda46cbc81dde3c1ec492a3f0f1305d8e180aba7ba644cf9e63a9706ef53c89e [Direct Link](https://github.com/ayufan-rock64/linux-build/releases/download/0.7.9/bionic-minimal-rock64-0.7.9-1067-arm64.img.xz)


2) Determine what CIDR block / DPCH range your nodes will occupy. 

The master is connected to wifi via a usb dongle.
The nodes recieve their internet access through a dnsmasq server
running on the master node through it's ethernet adapter.
This range is configured bysetting the range of the masters host_vars as follows:

`nodes_dhcp_range: "192.168.2.2,192.168.2.100"`

3) Plug each board into your router and un the pre-ansible-setup.sh script against each board with the boards temporary IP address

```bash
ansible/pre-ansible-setup.sh $HOST $NODE_NAME
```

```bash
ansible/pre-ansible-setup.sh 192.168.1.123 node-0
```

4) Set a static_ip for each node in host_vars. nd for your master.At this point the nodes may all be plugged into the switchRun ansible against each node using

```bash
ansible-playbook -i hosts.yml -l $HOST site.yml
```

5) At this point kubernetes is running but needs to be configured