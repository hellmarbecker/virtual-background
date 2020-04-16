# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.box = "debian/buster64"

  config.vm.hostname = "zoombox.localdomain"
  config.vm.network "private_network", ip: "192.168.17.31"
  config.ssh.forward_x11 = true

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    # Fix DNS for use with VPN tunnel,
    # see http://askubuntu.com/questions/238040/how-do-i-fix-name-service-for-vagrant-client
    vb.customize [ "modifyvm", :id, "--natdnshostresolver1", "on" ]
  end

  config.vm.provision :shell do |s|
    s.path = File.join( Dir.pwd, "provisioner.sh" )
  end

end
