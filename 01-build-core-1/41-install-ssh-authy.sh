#!/bin/bash
### ****************************************************************************
###
### Install and configure ssh-authy
###
### ****************************************************************************

# Check for api key
if [ -z ${__AUTHYAPIKEY+x} ]; then
	echo "ERROR: No Authy API Key found"
	return;
fi

# Download source files from GitHub
curl --progress-bar \
  --location --url "https://raw.github.com/authy/authy-ssh/master/authy-ssh" \
  --output ~/source/temp/authy-ssh
# copy in template config file
sudo cp ~/source/config/authy-ssh/authy-ssh.conf /usr/local/bin/authy-ssh.conf
# insert api key
sudo sed -i "s/^[ \t]*api_key.*/api_key=${__AUTHYAPIKEY}/" /usr/local/bin/authy-ssh.conf
# run install
sudo bash ~/source/temp/authy-ssh install /usr/local/bin

# Updated sshd_config and keep tidy
sudo sed -i "s,^[ \t]*ForceCommand[ \t]*/usr/local/bin/authy-ssh.*,\n# Use Authy-SSH\nForceCommand /usr/local/bin/authy-ssh login," /etc/ssh/sshd_config

# Create AUTHY flag file
touch ~/source/temp/ssh-authy

# Commit to etckeeper
if [ -e ~/source/temp/etckeeper ]; then 
  sudo etckeeper commit "Install and Configure Authy for SSH"
fi