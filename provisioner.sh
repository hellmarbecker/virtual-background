#!/bin/bash
#-------------------------------------------------------------------------------
# Provisioning script
#-------------------------------------------------------------------------------

# If the provisioner ran already, do nothing.
tagfile=/root/.provisioned

if [ -f $tagfile ] ; then
  echo "$0 : $tagfile already present, exiting"
  exit
fi
touch $tagfile

echo "$0 : running provisioner"

# code goes here

# Some prerequisites
echo "--- Updating system ---"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y update
sudo apt-get -y dist-upgrade
sudo apt-get -y install xauth
sudo apt-get -y install pulseaudio # for pactl
sudo apt-get -y install curl

# Python required packages
echo "--- Installing Python packages ---"
sudo apt-get -y install python3-pip
sudo pip3 install --upgrade pip
sudo pip3 install numpy

# Javascript dependencies
echo "--- Installing Node ---"
sudo apt-get -y install nodejs

# Zoom client
echo "--- Installing Zoom ---"
# For some reason, downloading from within the VM does not work
# curl -sL https://zoom.us/client/latest/zoom_amd64.deb -o /tmp/zoom_amd64.deb 
# Instead, the package must be in the vagrant directory on the host
sudo apt-get -y install /vagrant/zoom_amd64.deb

echo "$0 : done" 
