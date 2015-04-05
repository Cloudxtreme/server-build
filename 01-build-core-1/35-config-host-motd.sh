#!/bin/bash
### ****************************************************************************
###
### Config the MOTD messages
###
### ****************************************************************************

# disable unwanted messages
sudo chmod -x /etc/update-motd.d/10-help-text
sudo chmod -x /etc/update-motd.d/51-cloudguest

# replace the default landscape-sysinfo message
sudo cp /etc/update-motd.d/50-landscape-sysinfo /etc/update-motd.d/50-landscape-sysinfo.old
sudo sed -i 's:/usr/bin/landscape-sysinfo:/usr/bin/landscape-sysinfo --exclude-sysinfo-plugins=LandscapeLink:g' /etc/update-motd.d/50-landscape-sysinfo

# Commit to etckeeper
if [ -e /var/tmp/server-build/etckeeper ]; then 
  sudo etckeeper commit "Tweaks to MOTD generation"
fi


#50-landscape-sysinfo -> /usr/share/landscape/landscape-sysinfo.wrapper