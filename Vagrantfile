# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  config.vm.box = "debian/contrib-stretch64"

  config.vm.hostname = "zoombox.localdomain"
  config.vm.network "private_network", ip: "192.168.17.31"
  config.ssh.forward_x11 = true

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "512"
    # Fix DNS for use with VPN tunnel,
    # see http://askubuntu.com/questions/238040/how-do-i-fix-name-service-for-vagrant-client
    vb.customize [ "modifyvm", :id,
      "--name", "zoombox",
      "--vram", "256",
      "--accelerate3d", "on",
      "--clipboard", "bidirectional",
      "--hwvirtex", "on",
      "--nestedpaging", "on",
      "--largepages", "on",
      "--ioapic", "on",
      "--pae", "on",
      "--paravirtprovider", "kvm",
      "--natdnshostresolver1", "on",
      "--usb", "on",
      "--usbehci", "on",      
    ]
    # Attach webcam
    # TODO: how can we read out the default webcam?
    # Like using [VBoxManage list webcams]
    # vb.customize [ "controlvm", :id, "webcam", "attach", ".1" ]
  end

  # config.vm.provision :shell do |s|
  #   s.path = File.join( Dir.pwd, "provisioner.sh" )
  # end
  
  config.trigger.after [ :up, :reload ] do |trigger|
    # trigger.info = "Mount webcam to \"zoombox\""
    trigger.info = "VBox path is #{ENV['VBOX_MSI_INSTALL_PATH']}"
    trigger.run = {
      inline: "\"#{ENV['VBOX_MSI_INSTALL_PATH']}VBoxManage\" controlvm \"zoombox\" webcam attach .0",
    }
  end

end
