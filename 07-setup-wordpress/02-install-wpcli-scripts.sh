#!/bin/bash
### ****************************************************************************
###
### Install wp-cli scripts
###
### ****************************************************************************

# copy in scripts
sudo mkdir /data/www/scripts
sudo cp --recursive ~ubuntu/source/config/wpcli-scripts/* /data/www/scripts
sudo chmod a+x /data/www/scripts/*.sh