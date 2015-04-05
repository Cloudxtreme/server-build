#!/bin/bash
### ****************************************************************************
###
### Disable the ubuntu user (but don't delete it)
###
### ****************************************************************************

# Check /home/ubuntu folder
if [ ! -d /home/ubuntu ]; then
	echo "Ubuntu user not found"
	return
fi

# don't run this as the ubuntu user!
shopt -s nocasematch
if [ ${USER} == ubuntu ]; then
  echo "Please re-run this as a different user!"
  echo -e "You can't disable the ubuntu user whilst logged in as ubuntu\n\n"
  exit
else
  echo "Disabling the ubuntu user"
fi

# remove from all (potentially privileged and sensitive) groups
if [ -f ~ubuntu/.groups ]; then
	rm --force ~ubuntu/.groups
fi
sudo touch ~ubuntu/.groups
echo "# list of groups for ubuntu ($(date))" | sudo tee ~ubuntu/.groups
for g in $(id -Gn ubuntu);
do
	sudo sed -i "$ a${g}" ~ubuntu/.groups
	if [ ! ${g} == ubuntu ]; then
		sudo gpasswd --delete ubuntu ${g}
	fi
done
unset g

# disable ssh authorized keys
sudo mv ~ubuntu/.ssh/authorized_keys ~ubuntu/.ssh/authorized_keys_disabled

# disable sudo privileges
sudo sed -i '/^[ \t]*ubuntu/s/^/# /' /etc/sudoers.d/90-cloud-init-users
sudo sed -i "/# User rules/{s/$/ (updated $(date))/;}" /etc/sudoers.d/90-cloud-init-users

# finally, let's disable the account
sudo passwd --lock ubuntu
sudo passwd --expire ubuntu

# Make the home directory group writable and group sticky
sudo chmod g+rwxs ~ubuntu

# Commit to etckeeper
if [ -e /var/tmp/server-build/etckeeper ]; then 
  sudo etckeeper commit "Disabled ubuntu user"
fi