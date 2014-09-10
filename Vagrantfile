# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_NAME = "CentOS-6.4-x86"

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = BOX_NAME

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "./packer/vagrant-boxes/" + BOX_NAME + ".box"

  require 'vagrant-vbguest' unless defined? config.vbguest
  config.vbguest.auto_update = true

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network :forwarded_port, guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "192.168.56.103"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "synced", "/synced",:nfs => false, :mount_options => ["dmode=777,fmode=777"]

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider :virtualbox do |vb|
     # Don't boot with headless mode
     # vb.gui = true
     vb.name = BOX_NAME
     vb.customize ["modifyvm", :id, "--memory", "2048"]
     vb.customize ["modifyvm", :id, "--cpus", "2"]
     vb.customize ["modifyvm", :id, "--rtcuseutc", "off"]

     # Use VBoxManage to customize the VM. For example to change memory:
   end

   config.vm.provision "ansible" do |ansible|
     ansible.inventory_path = 'ansible/inventories/vagrant_local'
     ansible.playbook       = "ansible/site.yml"
     ansible.limit          = "all"
     ansible.verbose        = "vvv"
   end
end
