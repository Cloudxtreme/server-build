#!/bin/bash
### ****************************************************************************
###
### Configure automatic updates to use mail
###
### ****************************************************************************

# Enable emails for unattendedupgrade
sudo sed -i 's,^[ \t]*//[ \t]*Unattended-Upgrade::Mail[ \t].*,Unattended-Upgrade::Mail "root";,' /etc/apt/apt.conf.d/50unattended-upgrades

# Install apticron
sudo apt-get install apticron --assume-yes

# Configure apticron
sudo sed -i "s,^[ \t]*[\#][ \t]*CUSTOM_FROM.*,CUSTOM_FROM=\"Ubuntu \(${HOSTNAME}\) <${HOSTNAME}@${HOSTNAME}>\"," /etc/apticron/apticron.conf
sudo sed -i "s,^[ \t]*EMAIL.*,EMAIL=\"${HOSTNAME}@${HOSTNAME}\"," /etc/apticron/apticron.conf

sudo sed -i "s,^[ \t]*[\#]*[ \t]*CUSTOM_SUBJECT.*,CUSTOM_SUBJECT=\"Server \'${HOSTNAME}\' has \"\'\$NUM_PACKAGES package update(s) available\'," /etc/apticron/apticron.conf
sudo sed -i "s,^[ \t]*[\#]*[ \t]*CUSTOM_NO_UPDATES_SUBJECT.*,CUSTOM_NO_UPDATES_SUBJECT=\"Server \'${HOSTNAME}\' has no package update(s) available\"," /etc/apticron/apticron.conf

# Disable apt-listchanges notification during apt updates/upgrades
#sudo rm /etc/apt/apt.conf.d/20listchanges 
sudo sed -i "s,^[ \t]*frontend=.*,frontend=mail," /etc/apt/listchanges.conf
sudo sed -i "s,^[ \t]*which=.*,which=both," /etc/apt/listchanges.conf
#/etc/apt/listchanges.conf
#frontend=pager
#email_address=root

# Commit to etckeeper
if [ -e ~ubuntu/source/temp/etckeeper ]; then 
  sudo etckeeper commit "Confiured automatic updates to use mail"
fi