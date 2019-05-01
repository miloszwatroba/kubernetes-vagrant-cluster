#!/bin/bash -e

echo '[Kubernetes] Init kubeadm'
kubeadm init --apiserver-advertise-address=$IPADDR --apiserver-cert-extra-sans=$IPADDR --node-name $NODENAME --pod-network-cidr=192.168.0.0/16


echo '[Kubernetes] Setup kubeconfig for non-root user'
mkdir -p /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config
export KUBECONFIG=/home/vagrant/.kube/config


echo '[Kubernetes] Setup Dashboard UI'
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended/kubernetes-dashboard.yaml


echo '[Kubernetes] Install calico POD'
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml


echo '[Kubernetes] Allow running pods on master node'
kubectl taint nodes --all node-role.kubernetes.io/master-


echo '[Kubernetes] Copy join command'
kubeadm token create --print-join-command > /vagrant/scripts/join-command.sh
chmod +x /vagrant/scripts/join-command.sh
