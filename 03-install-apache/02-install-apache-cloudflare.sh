#!/bin/bash
### ****************************************************************************
###
### Install CloudFlare module for apache
###
### ****************************************************************************

# Install apache dev tools to get apxs2
###sudo apt-get install apache2-dev --assume-yes

# Disable remoteip module (conflicts with cloudflare)
sudo a2dismod remoteip

# Install & enable cloudflare module
wget https://raw.github.com/cloudflare/mod_cloudflare/master/mod_cloudflare.c
sudo apxs2 -a -i -c mod_cloudflare.c

# Commit to etckeeper
if [ -e /var/tmp/server-build/etckeeper ]; then 
  sudo etckeeper commit "Installed CloudFlare module for Apache"
fi