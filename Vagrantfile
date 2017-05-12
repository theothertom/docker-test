# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.network "private_network", ip: "192.168.33.10"

  #In testing, Vagrant didn't bring up eth1
  config.vm.provision "shell" do |shell|
    shell.inline = "/sbin/ifup eth1"
  end
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "VM/playbooks/base.yml"
    ansible.sudo = true
  end
end
