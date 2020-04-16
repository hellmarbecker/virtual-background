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
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y update
sudo apt-get -y dist-upgrade
sudo apt-get -y install nodejs

echo "$0 : done" 
