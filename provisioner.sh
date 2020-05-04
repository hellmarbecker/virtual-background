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
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y update
sudo apt-get -y dist-upgrade
sudo apt-get -y install xauth
sudo apt-get -y install curl

# Python required packages
sudo apt-get -y -qq install python3-pip
sudo pip3 install --upgrade pip
sudo pip3 install numpy

# Javascript dependencies
sudo apt-get -y install nodejs

# Zoom client
curl -L -O https://zoom.us/client/latest/zoom_amd64.deb

echo "$0 : done" 
