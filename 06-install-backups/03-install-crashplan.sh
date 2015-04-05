#!/bin/bash
### ****************************************************************************
###
### Install CrashPlan Headless Server
###
### ****************************************************************************

### strongly consider running this only once xterm support is installed and configured

# update the version number in URL manually to latest version
curl --progress-bar --location \
     --url "http://download.crashplan.com/installs/linux/install/CrashPlan/CrashPlan_3.7.0_Linux.tgz" \
     --output /var/tmp/server-build/crashplan.tar.gz 

tar --gzip --extract --file /var/tmp/server-build/crashplan.tar.gz --directory /var/tmp/server-build/

# increase the number of files watched by the system
echo -e "# CrashPlan Service\n# Increase the number of files watched in real time\nfs.inotify.max_user_watches=65000" | sudo tee -a /etc/sysctl.d/60-crashplan.conf
echo -e "65000" | sudo tee /proc/sys/fs/inotify/max_user_watches

# run the interactive install - no silent option available!
cd /var/tmp/server-build/CrashPlan-install
sudo ./install.sh 

### once install we will need to connect a client or XTerm to the server to configure CrashPlan

# Commit to etckeeper
if [ -e /var/tmp/server-build/etckeeper ]; then 
  sudo etckeeper commit "Installed CrashPlan"
fi