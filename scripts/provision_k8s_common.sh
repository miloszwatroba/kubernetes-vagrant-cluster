#!/bin/bash -e

echo '[Docker] Install docker'
apt-get update && apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

apt-get update && apt-get install -y docker-ce=18.06.2~ce~3-0~ubuntu


echo '[Docker] Setup daemon'
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d


echo '[Docker] Restart'
systemctl daemon-reload
systemctl restart docker


echo '[Docker] Adding permissions for user vagrant'
usermod -aG docker vagrant


echo '[Kubernetes] Install kubelet, kubeadm and kubectl'
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl


echo '[Utils] Put down IP address'
echo "$NODENAME $IPADDR" >> /vagrant/ips.txt


echo '[Utils] Disable swapoff'
swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
