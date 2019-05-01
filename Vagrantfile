WORKERS=2
OS_IMAGE="bento/ubuntu-16.04"

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end

  config.vm.define "k8s-master" do |master|
    master.vm.box = OS_IMAGE
    master.vm.network "private_network", type: "dhcp"
    master.vm.hostname = "k8s-master"
    master.vm.provision "docker"
    master.vm.provision "shell", path: "provision_k8s_common.sh"
    master.vm.provision "shell", path: "provision_k8s_master.sh"
  end

  (1..WORKERS).each do |i|
    config.vm.define "k8s-worker-#{i}" do |node|
      node.vm.box = OS_IMAGE
      node.vm.network "private_network", type: "dhcp"
      node.vm.hostname = "k8s-worker-#{i}"
      node.vm.provision "docker"
      node.vm.provision "shell", path: "provision_k8s_common.sh"
      node.vm.provision "shell", inline: "sh /vagrant/join-command.sh"
    end
  end
end
