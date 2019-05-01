require 'getoptlong'

OS_IMAGE="bento/ubuntu-16.04"
workers=1

opts = GetoptLong.new(
    [ '--scale', GetoptLong::OPTIONAL_ARGUMENT ]
)

opts.ordering=(GetoptLong::REQUIRE_ORDER)

opts.each do |opt, arg|
  case opt
  when '--scale'
    workers = arg.to_i
  end
end

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
    master.vm.provision "shell", inline: "cp /vagrant/scripts/set_env_vars.sh /etc/profile.d/"
    master.vm.provision "shell", path: "scripts/provision_k8s_common.sh"
    master.vm.provision "shell", path: "scripts/provision_k8s_master.sh"
  end

  (1..workers).each do |i|
    config.vm.define "k8s-worker-#{i}" do |node|
      node.vm.box = OS_IMAGE
      node.vm.network "private_network", type: "dhcp"
      node.vm.hostname = "k8s-worker-#{i}"
      node.vm.provision "shell", inline: "cp /vagrant/scripts/set_env_vars.sh /etc/profile.d/"
      node.vm.provision "shell", path: "scripts/provision_k8s_common.sh"
      node.vm.provision "shell", path: "scripts/join-command.sh"
    end
  end
end
