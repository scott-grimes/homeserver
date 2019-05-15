# Minikube
sudo minikube --vm-driver=none start
helm init
helm install --name metallb --namespace metallb-system metallb
sh pihole/install.sh
helm install prometheus --name prometheus
helm install grafana --name grafana