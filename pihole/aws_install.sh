#!/bin/sh 
MAX_WAIT=120 #seconds
WAIT_INTERVAL=5 #seconds
DIR="$PWD/pihole"

# create first service
i=0
kubectl create -f "$DIR/svc.yaml"
DNS_NAME=$(kubectl get svc pihole -ojson | jq -r '.status.loadBalancer.ingress[0].hostname')
echo "Waiting for LB to provision DNS"

while [ -z "$DNS_NAME" ] || [ "$DNS_NAME" == "null" ]
do
    if [[ $i -gt $MAX_WAIT ]]; then
        echo "Timeout!"
        exit 1;
    fi
    DNS_NAME=$(kubectl get svc pihole -ojson | jq -r '.status.loadBalancer.ingress[0].hostname')
    i=$((i+1))
    printf "$i\r"
    sleep $WAIT_INTERVAL
done
echo "Provisioned $DNS_NAME"
echo "Waiting for IP to resolve"
i=0

# get ip address of first service
until host $DNS_NAME > /dev/null 2>&1
do
     if [[ $i -gt $MAX_WAIT ]]; then
        echo "Timeout!"
        exit 1;
    fi
    i=$((i+1))
    printf "$i\r"
    sleep $WAIT_INTERVAL
done

IP=$(host $DNS_NAME | awk '{print $NF}')
echo "IP is $IP"


# Deploying the rest of the app

svc_udp=$(cat "$DIR/svc_udp.yaml" | sed "s/EXTERNAL_IP_ADDRESS/$IP/g")
deployment=$(cat "$DIR/deployment.yaml" | sed "s/EXTERNAL_IP_ADDRESS/$IP/g")
echo "$svc_udp" | kubectl apply -f - && \
echo "$deployment" | kubectl apply -f - && \
exit 0
echo "Failed"
exit 1