#!/bin/bash
### ****************************************************************************
###
### WEBDRIVE specific host changes
###
### ****************************************************************************

# Disable password for the root account
sudo passwd -dl root

# Update hosts file
sudo apt-get install cloud-utils --assume-yes
sudo mv /etc/hosts /etc/hosts.old
echo -e "# host name\n$(ip route get 8.8.8.8 | awk '{print $NF; exit}') $(hostname).wd $(hostname)" | sudo tee /etc/hosts
sudo cat /etc/hosts.old | sudo tee -a /etc/hosts
sudo rm /etc/hosts.old
sudo hostname -b -F /etc/hostname

# Set name of CLOUD specific profile changes (found in config/profile)
touch /var/tmp/server-build/cloudprofile
echo 73-cloud-prompt.sh >> /var/tmp/server-build/cloudprofile

# Set name of WD specific profile changes (found in config/profile)
echo 72-wd-profile.sh >> /var/tmp/server-build/cloudprofile

# Add server verion/distribution details
echo 71-set-distro.sh >> /var/tmp/server-build/cloudprofile

# Set ssh public key to use
echo wd_openleaf_keypairA > /var/tmp/server-build/sshkey

# Link /mnt (EBS volume) to /data if it exists, otherwise just create /data
mount | grep --quiet 'on /mnt type ext3 (rw)' && sudo ln -s /mnt /data || sudo mkdir /data