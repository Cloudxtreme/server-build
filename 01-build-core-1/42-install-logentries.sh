#!/bin/bash
### ****************************************************************************
###
### Install and configure logentries
###
### ****************************************************************************

### check for key
if [ -z ${__LOGENTRIESACCTKEY+x} ]; then
	echo "ERROR: No LogEntries Account Key found"
	return;
fi

# download logentries package signing key
gpg --keyserver pgp.mit.edu --recv-keys C43C79AD
gpg -a --output /var/tmp/server-build/logentries.key --export C43C79AD
gpg --batch --yes --delete-key C43C79AD

# add logentries package signing key to apt keyring
if [ -d /etc/apt/trusted.gpg.d ]; then
	gpg --no-default-keyring --keyring /var/tmp/server-build/logentries.gpg --import /var/tmp/server-build/logentries.key
	sudo cp /var/tmp/server-build/logentries.gpg /etc/apt/trusted.gpg.d/logentries.gpg
else
	sudo apt-key add /var/tmp/server-build/logentries.key
fi

# update package source list
if [ -d /etc/apt/sources.list.d/ ]; then
	LISTFILE=/etc/apt/sources.list.d/logentries.list
 	sudo touch ${LISTFILE}
else
	LISTFILE=/etc/apt/sources.list
	echo -e "\n" | sudo tee -a ${LISTFILE}
fi
echo -e "##\n## logentries package sources - see 'https://github.com/logentries/le/blob/master/INSTALL.md'" | sudo tee -a ${LISTFILE}
echo -e "## added $(date)\n##" | sudo tee -a ${LISTFILE}
echo "deb http://rep.logentries.com/ $(lsb_release -sc) main" | sudo tee -a ${LISTFILE}

# update package lists
sudo apt-get update --quiet

# Setup 'DNSHOSTNAME' variable (see config/profile/7x-xxx-profile.sh)
if [ -e /var/tmp/server-build/cloudprofile ]; then 
  for f in $(</var/tmp/server-build/cloudprofile)
  do
    . /var/tmp/server-build/source/config/profile/${f}
  done
  unset f
fi

# install logentries agent
sudo apt-get install logentries --assume-yes

# register logentries - ACCOUNT KEY IS PRIVATE
sudo le register --name=${HOSTNAME} --hostname=${HOSTLOCATION:-CLOUD/unspecified} --account-key ${__LOGENTRIESACCTKEY}

# install logentries daemon
sudo apt-get install logentries-daemon --assume-yes

# Configure log entries agent with basic server logs
sudo le follow /var/log/syslog --name=syslog
sudo le follow "/var/log/apt/*.log" --name=apt
sudo le follow "/var/log/dist-upgrade/*.log" --name=dist-upgrade
sudo le follow "/var/log/unattended-upgrades/*.log" --name=unattended-upgrades
sudo le follow "/var/log/auth.log" --name=auth
sudo service logentries restart

# Create LOGENTRIES flag file
touch /var/tmp/server-build/logentries

# Commit to etckeeper
if [ -e /var/tmp/server-build/etckeeper ]; then 
  sudo etckeeper commit "Install & Configure Log Entries Agent"
fi