#!/usr/bin/env bash
USER=rock64
HOST=$1
NODE_NAME=$2
PUBLIC_KEY=$(cat ~/.ssh/id_rsa.pub)

ssh $USER@$HOST /bin/bash << EOF
# install my public key on remote machine
mkdir -p ~/.ssh && echo "${PUBLIC_KEY}" >> ~/.ssh/authorized_keys;

# add user to /etc/sudoers
echo rock64 | \
  sudo -S bash -c 'echo "rock64 ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers'

# install python for ansible
sudo apt-get update
sudo apt-get install -y python3.6
EOF