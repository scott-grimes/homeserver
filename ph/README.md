# Pihole for kubernetes

1) Deploy svc.yaml
```
kubectl create -f pihole/svc.yaml
```

2) 
if on aws, get the dns name created by the ip
```
DNS_NAME=$(kubectl get svc pihole -ojson | jq -r '.status.loadBalancer.ingress[0].hostname')
echo $DNS_NAME
```
then find the exteral ip address using
```
host $DNS_NAME 
```

3) Use the external ip from "kubectl describe svc" or step 2 (if on aws)
replace the values of EXTERNAL_IP_ADDRESS with your actual ip address in svc_udp.yaml and deployment.yaml

4) deploy the rest of the files
