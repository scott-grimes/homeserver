#!/bin/sh 
MAX_WAIT=120 #seconds
WAIT_INTERVAL=5 #seconds
DIR="$PWD/pihole"

# create first service
i=0
kubectl create -f "$DIR/svc.yaml"
IP=$(kubectl get svc pihole -ojson | jq -r '.status.loadBalancer.ingress[0].ip')
echo "Waiting for LB to provision ip"

while [ -z "$IP" ] || [ "$IP" = "null" ]
do
    if [[ $i -gt $MAX_WAIT ]]; then
        echo "Timeout!"
        exit 1;
    fi
    IP=$(kubectl get svc pihole -ojson | jq -r '.status.loadBalancer.ingress[0].ip')
    i=$((i+1))
    printf "$i\r"
    sleep $WAIT_INTERVAL
done
echo "Provisioned $IP"


# Deploying the rest of the app

svc_udp=$(cat "$DIR/svc_udp.yaml" | sed "s/EXTERNAL_IP_ADDRESS/$IP/g")
deployment=$(cat "$DIR/deployment.yaml" | sed "s/EXTERNAL_IP_ADDRESS/$IP/g")
echo "$svc_udp" | kubectl apply -f - && \
echo "$deployment" | kubectl apply -f - && \
exit 0
echo "Failed"
exit 1