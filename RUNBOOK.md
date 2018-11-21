# RUNBOOK

# minikube
```
minikube start --bootstrapper=kubeadm 
```

## Cluster Setup

See BAREMETAL or AWS files to create a new cluster, once kubeconfig has the cluster context set to our cluster, proceed.

Run
```
helm init
```
to prepare the cluster for installations via helm
NOTE: need to add tls verification later

## Ingress via Traefik?

1. Run
```
helm install --name traefik --namespace kube-system traefik
```

2. Wait until EXTERNAL-IP is finished loading, check using the command
```
kubectl get svc traefik --namespace kube-system
```

3. Visit http://dashboard.cluster



## Monitor - Prometheus and Grafana

