#!/bin/bash
### ****************************************************************************
###
### Create new user
###
### ****************************************************************************

if [ -z ${__NEWUSERAUTHYINFO+x} ]; then
	echo "ERROR: No authy access information found for user account"
	return;
fi
if [ -z ${__NEWUSERNAME+x} ]; then
	echo "ERROR: No name found for user account"
	return;
fi
if [ -z ${__NEWUSERUID+x} ]; then
	echo "ERROR: No UID found for user account"
	return;
fi
if [ -z ${__NEWUSERLONGNAME+x} ]; then
	echo "ERROR: No full name found for user account"
	return;
fi

NEWUSER=${__NEWUSERNAME}
NEWUSERID=${__NEWUSERUID}
NEWUSERNAME=${__NEWUSERLONGNAME}

# create non-default account with GID=UID
sudo groupadd --gid ${NEWUSERID} ${NEWUSER}
sudo useradd --uid ${NEWUSERID} --gid ${NEWUSERID} --shell ${BASH} --create-home --comment "${NEWUSERNAME}" ${NEWUSER}

# make the homedir group sticky and group writable
NEWUSERHOME=$(getent passwd "${NEWUSER}" | cut -d: -f 6)
sudo chmod g+rwxs ${NEWUSERHOME}

# set a password (user will login with ssh keys, but will require a password for access to sudo)
echo -e "Setting password for ${NEWUSER}...\n"
until sudo passwd ${NEWUSER}; do echo -e "\nPlease try again\n"; done

# add to additional groups - CHECK BEFORE COPYING FOR OTHER USERS
sudo usermod -a -G adm ${NEWUSER}
sudo usermod -a -G backup ${NEWUSER}
sudo usermod -a -G sudo ${NEWUSER}
sudo usermod -a -G www-data ${NEWUSER}
sudo usermod -a -G ubuntu ${NEWUSER} 

# grant ssh access via group control - CHECK BEFORE COPYING FOR OTHER USERS
sudo gpasswd --add ${NEWUSER} sshlogin

# configure authy-ssh for two-factor authentication - CHECK BEFORE COPYING FOR OTHER USERS
if [ -e /var/tmp/server-build/ssh-authy ]; then 
  echo "Enabling user for Authy-SSH"
  sudo /usr/local/bin/authy-ssh enable ${NEWUSER} ${__NEWUSERAUTHYINFO}
fi

# set up ssh keys
sudo mkdir ${NEWUSERHOME}/.ssh
sudo cp /var/tmp/server-build/source/config/ssh/$(cat /var/tmp/server-build/sshkey).pub ${NEWUSERHOME}/.ssh/authorized_keys
#sudo cp ~ubuntu/.ssh/authorized_keys ${NEWUSERHOME}/.ssh/authorized_keys
sudo chown -R ${NEWUSER}:${NEWUSER} ${NEWUSERHOME}/.ssh
sudo chmod 0700 ${NEWUSERHOME}/.ssh
sudo chmod g-s ${NEWUSERHOME}/.ssh
sudo chmod 600 ${NEWUSERHOME}/.ssh/authorized_keys

# disable sudo help messages
sudo touch ${NEWUSERHOME}/.sudo_as_admin_successful
sudo chown ${NEWUSER}:${NEWUSER} ${NEWUSERHOME}/.sudo_as_admin_successful

# Commit to etckeeper
if [ -e /var/tmp/server-build/etckeeper ]; then 
  sudo etckeeper commit "Added user ${NEWUSER}"
fi


###### Other ideas/options...

# setup first login actions
#sudo cp ${NEWUSERHOME}/.profile ${NEWUSERHOME}/.profile.old
#sudo chown ${NEWUSER}:${NEWUSER} ${NEWUSERHOME}/.profile.old
#echo "/var/tmp/server-build/source/build/49x-user-disable-ubuntu.sh" | sudo tee -a ${NEWUSERHOME}/.profile
#echo rm ${NEWUSERHOME}/.profile | sudo tee -a ${NEWUSERHOME}/.profile
#echo mv ${NEWUSERHOME}/.profile.old ${NEWUSERHOME}/.profile | sudo tee -a ${NEWUSERHOME}/.profile

# copy GitHub ssh keys
#sudo cp /var/tmp/server-build/source/config/github-ssh/github-* ${NEWUSERHOME}/.ssh/
#cat /var/tmp/server-build/source/config/github-ssh/known_hosts | sudo tee -a ${NEWUSERHOME}/.ssh/known_hosts
#cat /var/tmp/server-build/source/config/github-ssh/config | sudo tee -a ${NEWUSERHOME}/.ssh/config
#sudo find ${NEWUSERHOME}/.ssh -type f -exec chown ${NEWUSER}:${NEWUSER} {} \;
#sudo find ${NEWUSERHOME}/.ssh -type f -exec chmod 600 {} \;

### don't set a password, and lock the account
# sudo usermod --lock ${NEWUSER}
### add to sudoers list and don't require a password
#sudo touch /etc/sudoers.d/99-nopasswd-${NEWUSER}
#sudo chmod 0440 /etc/sudoers.d/99-nopasswd-${NEWUSER}
#echo -e "\n" | sudo tee -a /etc/sudoers.d/99-nopasswd-${NEWUSER}
#sudo sed -i "1i\# User ${NEWUSER} replaces the default ubuntu user.\n# Therefore ${NEWUSER} needs passwordless sudo functionality.\n\n# User rules for ${NEWUSER}\n${NEWUSER} ALL=(ALL) NOPASSWD:ALL" /etc/sudoers.d/99-nopasswd-${NEWUSER}
