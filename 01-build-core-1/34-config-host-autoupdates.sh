#!/bin/bash
### ****************************************************************************
###
### Automatic updates configuration
###
### ****************************************************************************

# make sure unattended-upgrades package is installed
sudo apt-get install unattended-upgrades --assume-yes

# copy periodic update config file
sudo cp /var/tmp/server-build/source/config/apt-conf/10periodic /etc/apt/apt.conf.d/10periodic

# change what updates are applied (default is security updates only)
#sudo cp ~ubuntu/source/config/apt-conf/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades

# Commit to etckeeper
if [ -e /var/tmp/server-build/etckeeper ]; then 
  sudo etckeeper commit "Configure apt auto updates via unattended-upgrades"
fi