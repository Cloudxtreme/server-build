#!/bin/bash
### ****************************************************************************
###
### Base server configuration
###
### ****************************************************************************

# Update apt package list
sudo apt-get update --yes

# Install utilities
sudo apt-get install zip unzip pwgen nmap --assume-yes

# Other useful packages
sudo apg-get install members nmap --assume-yes

# Time-zone (Pacific/Auckland)
echo "Pacific/Auckland" | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata

# Remove unwanted packages
sudo apt-get --purge remove popularity-contest whoopsie apport --assume-yes

# update installation
# (see http://askubuntu.com/questions/146921/how-do-i-apt-get-y-dist-upgrade-without-a-grub-config-prompt)
unset UCF_FORCE_CONFFOLD
export UCF_FORCE_CONFFNEW=YES
sudo -E ucf --purge /boot/grub/menu.lst
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo -E apt-get --option Dpkg::Options::="--force-confdef" --option Dpkg::Options::="--force-confold" dist-upgrade --assume-yes --fix-missing --fix-broken 
#sudo apt-get dist-upgrade --assume-yes --fix-missing --fix-broken

# Clean-up
sudo apt-get check --yes
sudo apt-get autoclean --yes
sudo apt-get autoremove --yes