# RUNBOOK

# start minikube
```
minikube start --bootstrapper=kubeadm 

helm init

helm install --name metallb --namespace  metallb-system metallb
```

# deploying an app

```
kubectl run nginx --image=nginx --port=80 
kubectl expose deployment nginx --type LoadBalancer
```

# testing the app
```

```