# INGRESS


1. Run
```
helm install --name traefik ingress/traefik
```

2. Wait until EXTERNAL-IP is finished loading, check using the command
```
kubectl get svc traefik --namespace default
```

3. Visit http://traefik.cluster

to do: specify static ip for ingress?

