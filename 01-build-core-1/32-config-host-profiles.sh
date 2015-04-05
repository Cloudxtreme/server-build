#!/bin/bash
### ****************************************************************************
###
### Configure additional default profile settings
###
### ****************************************************************************

# Copy in the common (80-89) additional profile.d files
sudo cp /var/tmp/server-build/source/config/profile/8?-*.sh /etc/profile.d/
for f in /var/tmp/server-build/source/config/profile/8?-*.sh
do
	sudo chmod a+x /etc/profile.d/$(basename $f)
	. /etc/profile.d/$(basename $f)
done
unset f

# Install the cloud (7x) profile changes for bash/sh users
if [ -e /var/tmp/server-build/cloudprofile ]; then 
  for f in $(</var/tmp/server-build/cloudprofile)
  do
    sudo cp /var/tmp/server-build/source/config/profile/${f} /etc/profile.d/${f}
    sudo chmod a+x /etc/profile.d/${f}
    . /etc/profile.d/${f}
  done
  unset f
fi

# Commit to etckeeper
if [ -e /var/tmp/server-build/etckeeper ]; then 
  sudo etckeeper commit "Configure user profile defaults"
fi