#!/bin/bash
### ****************************************************************************
###
### Install etckeeper and configure it to use git
###
### ****************************************************************************

# Install etckeeper and git-core
sudo apt-get install git-core etckeeper --assume-yes

# Configure etckeep to use git
sudo sed -i "s/^[ \t]*VCS=\"bzr\".*/#VCS=\"bzr\"/" /etc/etckeeper/etckeeper.conf
sudo sed -i "s/^[ \t]*#VCS=\"git\".*/VCS=\"git\"/" /etc/etckeeper/etckeeper.conf

# Run first commit
sudo etckeeper init
sudo etckeeper commit "Initial commit"

# pack git repo to save a lot of space
pushd /etc
sudo git gc 
popd

# Create ETCKEEPER flag file
touch ~/source/temp/etckeeper