# RUNBOOK


## Cluster Setup

Starting with a clean cluster
```
helm init
```

## Ingress via Traefik

note: on minikube the external ip will not be exposed unless you run
```
kubectl run minikube-lb-patch --replicas=1 --image=elsonrodriguez/minikube-lb-patch:0.1 --namespace=kube-system
```

you can undo the patch by running
```
kubectl  delete deployment minikube-lb-patch -nkube-system
```

1. Run
```
helm install --name traefik --namespace kube-system ingress/traefik
```

2. Wait until EXTERNAL-IP is finished loading, check using the command
```
kubectl get svc traefik --namespace kube-system
```

3. Visit http://dashboard.cluster



## Monitor - Prometheus and Grafana

