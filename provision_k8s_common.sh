#!/bin/bash -e

NODENAME=`hostname -s`

echo 'Installing kukelet, kubeadm and kubectl...'
apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl


echo 'Get IP address'
IPADDR=`ifconfig eth1 | grep -i Mask | awk '{print $2}'| cut -f2 -d:`
echo "$NODENAME $IPADDR" >> /vagrant/ips.txt


echo 'Disable swapoff'
swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
