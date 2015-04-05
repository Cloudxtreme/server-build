#!/bin/bash
### ****************************************************************************
###
### Install wp-cli scripts
###
### ****************************************************************************

# copy in scripts
sudo mkdir /data/www/scripts
sudo cp --recursive /var/tmp/server-build/source/config/wpcli-scripts/* /data/www/scripts
sudo chown root:www-data /data/www/scripts/*.sh
sudo chmod a+x /data/www/scripts/*.sh