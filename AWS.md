# Set up Cluster on AWS

Install Kops / Kubectl / AWS CLI and configure aws credentials

## Create bucket for kops state store
s-test-kops-state-store is the bucket name!
```
aws s3api create-bucket --bucket s-test-kops-state-store --region us-east-1
```

## Enable bucket versioning to for rollbacks
```
aws s3api put-bucket-versioning --bucket s-test-kops-state-store --versioning-configuration Status=Enabled
```

## add envvars to make life easier to your .bashrc file
note: cluster names which end in k8s.local use the gossip protocol
```
export KOPS_CLUSTER_NAME=stest.k8s.local
export KOPS_STATE_STORE=s3://s-test-kops-state-store
```

## create initial cluter config
```
kops create cluster --node-count=1 --node-size=t2.small --zones=us-east-1a
```

## edit the cluster if needed
```
kops edit cluster
```

## create the cluster
```
kops update cluster --name ${KOPS_CLUSTER_NAME} --yes
```

## validate the cluster is running
```
kops validate cluster
```

## check nodes (make sure your kubectl config is pointing to the new cluster)
```
kubectl get nodes
```


## delete the cluster
you must append --yes to actually delete cluster
```
kops delete cluster --name ${KOPS_CLUSTER_NAME} --yes
```



## install helm, allow helm to deploy in cluster

```
helm init
```
need to add tls verification later!

give helm permissions

```
kubectl create serviceaccount --namespace kube-system tiller  
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller  
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}' 
```