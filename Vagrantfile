# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # Use Debian Stretch - I had issues with package hashes when using Python 3 on Debian Buster
  config.vm.box = "debian/contrib-stretch64"

  config.vm.hostname = "zoombox.localdomain"
  config.vm.network "private_network", ip: "192.168.17.31"

  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    # "--natdnshostresolver1": Fix DNS for use with VPN tunnel,
    # see http://askubuntu.com/questions/238040/how-do-i-fix-name-service-for-vagrant-client.
    # Most of the other options are courtesy of 
    # https://github.com/yoneken/Win-vagrant-Ubuntu-webcam.
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
  end

  config.vm.provision :shell do |s|
    s.path = File.join( Dir.pwd, "provisioner.sh" )
  end
  
  config.trigger.after [ :up, :reload ] do |t|
    # Attach webcam
    # Possible upgrade: Select webcam instead of just using the default ".0",
    # like using [VBoxManage list webcams]
    # Note: VirtualBox does not put itself into PATH and I don't wnat to change that,
    # so read out the install path from the corresponding environment variable
    t.info = "Mount webcam to \"zoombox\". VirtualBox path is #{ENV['VBOX_MSI_INSTALL_PATH']}"
    t.run = {
      path: File.join( ENV['VBOX_MSI_INSTALL_PATH'], "VBoxManage.exe" ),
      args: [ "controlvm", "zoombox", "webcam", "attach", ".0" ],
    }
  end

end
