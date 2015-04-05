#!/bin/bash
### ****************************************************************************
###
### Configure git
###
### ****************************************************************************

# Install git
sudo apt-get install git --assume-yes

# Set some universal standards
sudo git config --system push.default simple
sudo git config --system color.ui auto
sudo git config --system core.autocrlf input
sudo git config --system core.pager 'less -FRSX'
sudo git config --system branch.autosetuprebase always

# Setup 'USERNAME' variable (see config/profile/81-set-username.sh)
. /var/tmp/server-build/source/config/profile/81-set-username.sh
# Setup 'DNSHOSTNAME' variable (see config/profile/7x-xxx-profile.sh)
if [ -e /var/tmp/server-build/cloudprofile ]; then 
  for f in $(</var/tmp/server-build/cloudprofile)
  do
    . /var/tmp/server-build/source/config/profile/${f}
  done
  unset f
fi

# Configure .gitconfig for current user, root and www-data
git config --global user.name ${USERNAME:-${USER^}}
git config --global user.email ${USER}@${DNSHOSTNAME:-$HOSTNAME.cloud}
sudo -H git config --global user.name root-${HOSTNAME}
sudo -H git config --global user.email root@${DNSHOSTNAME:-$HOSTNAME.cloud}
sudo -Hu www-data git config --global user.name www-data
sudo -Hu www-data git config --global user.email www-data@${DNSHOSTNAME:-$HOSTNAME.cloud}
