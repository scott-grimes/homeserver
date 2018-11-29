#!/bin/sh 

DIR="$PWD/pihole"

kubectl create -f "$DIR/svc.yaml" && \
kubectl create -f "$DIR/svc_udp.yaml" && \
kubectl create -f "$DIR/deployment.yaml" && \
exit 0
echo "Failed"
exit 1