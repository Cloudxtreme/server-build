#!/bin/bash
### ****************************************************************************
###
### Install and configure wp-cli utility (http://wp-cli.org)
###
### Assumes:
###  - PHP CLI installed (otherwise this is useless)
###
### ****************************************************************************

# get wp-cli tool
curl --progress-bar --location \
     --url https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
     --output ~ubuntu/source/temp/wp-cli.phar

# get bash completion file
curl --progress-bar --location \
     --url https://github.com/wp-cli/wp-cli/raw/master/utils/wp-completion.bash \
     --output ~ubuntu/source/temp/wp-completion.bash

# move wp-cli to /usr/local/bin
sudo cp ~ubuntu/source/temp/wp-cli.phar /usr/local/bin/wp
sudo chmod +x /usr/local/bin/wp

# add wp-cli bash completion
sudo cp ~ubuntu/source/temp/wp-completion.bash /etc/bash_completion.d/wp-cli
source /etc/bash_completion.d/wp-cli

# setup a default config with sensible defaults in /data/www
# alternative is to copy it into ~/.wp-cli/config.yml
sudo cp ~ubuntu/source/config/wpcli-conf/config.yml /data/www/wp-cli.local.yml
sed -i "s/^core install:$/core config:\n  server: ${PUBLICIP}/" /data/www/wp-cli.local.yml

### This code may be needed if using a reverse proxy
### like CloudFlare but it breaks wp-cli so if needed
### add manually to wp-config
#    /** Handle reverse-proxy https */
#    if ($_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https')
#           $_SERVER['HTTPS']='on';

# Commit to etckeeper
if [ -e ~ubuntu/source/temp/etckeeper ]; then 
  sudo etckeeper commit "Installed wp-cli"
fi