# Minikube
sudo minikube --vm-driver=none start
helm init
helm install --name metallb --namespace metallb-system metallb

sh pihole/install.sh

usually this runs at 192.168.1.240

dig ads.nexage.com @192.168.1.240
digging does not work :(

kubectl exec -it [pihole pod] -- /bin/bash
shelling into container works
dig ads.nexage.com @localhost

inspect service?

check server ip when creating deployment?