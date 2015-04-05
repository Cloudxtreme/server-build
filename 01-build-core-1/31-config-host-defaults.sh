#!/bin/bash
### ****************************************************************************
###
### Configure some default settings for the host
###
### ****************************************************************************

# Change default editor to vi
sudo rm /etc/alternatives/editor
sudo ln -s /usr/bin/vi /etc/alternatives/editor

# Change default shell for new users to bash
sudo useradd -D -s $BASH

# Commit to etckeeper
if [ -e /var/tmp/server-build/etckeeper ]; then 
  sudo etckeeper commit "Configure host defaults"
fi