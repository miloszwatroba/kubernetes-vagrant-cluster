#!/bin/bash -e

NODENAME=`hostname -s`
IPADDR=`ifconfig eth1 | grep -i Mask | awk '{print $2}'| cut -f2 -d:`

echo 'Init kubeadm'
kubeadm init --apiserver-advertise-address=$IPADDR --apiserver-cert-extra-sans=$IPADDR --node-name $NODENAME --pod-network-cidr=192.168.0.0/16


echo 'Setup kubeconfig for non-root user'
sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf


echo 'Install calico POD'
kubectl create -f https://docs.projectcalico.org/v3.4/getting-started/kubernetes/installation/hosted/calico.yaml


echo 'Allow running pods on master node'
kubectl taint nodes --all node-role.kubernetes.io/master-

echo 'Copy join command'
kubeadm token create --print-join-command > /vagrant/join-command.sh
chmod +x /vagrant/join-command.sh
