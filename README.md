# Vagrant Kubernetes cluster
Easily scalable Vagrant based Kubernetes cluster created for development and educational purposes.

## Getting started
```bash
vagrant up
```

## Scaling up
```bash
vagrant --scale=N up
```
where N is the number of worker nodes

## VMs IP addresses
As soon as the cluster is set up you will see the `ips.txt` containing a list of nodes names and their IP addresses in the project root directory.

## Listing all services
```bash
vagrant ssh k8s-master -- kubectl get services --all-namespaces
```

## Exposing dashboard UI
**IMPORTANT: due to security reasons, never use such solution only for production purposes!**

1. Edit kubernetes-dashboard service and change type: ClusterIP to type: NodePort and save the configuration.
```bash
vagrant ssh k8s-master
kubectl -n kube-system edit service kubernetes-dashboard
```

2. To grant admin privileges to the dashboard's service account create ClusterRoleBinding using.
```
vagrant ssh k8s-master -- kubectl create -f /vagrant/dashboard-admin.yaml
```

3. Get token with kubectl to access the dashboard
```bash
kubectl -n kube-system describe secrets `kubectl -n kube-system get secret | grep kubernetes-dashboard-token | awk '{print $1}'` | grep token: | awk '{print $2}'
```
