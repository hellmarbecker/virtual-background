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

echo "$0 : done" 
