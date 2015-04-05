#!/bin/bash
### ****************************************************************************
###
### Install apache scripts
###
### ****************************************************************************

sudo mkdir /data/www/scripts
sudo cp --recursive /var/tmp/server-build/source/config/apache-scripts/* /data/www/scripts
sudo chown root:www-data /data/www/scripts/*.sh
sudo chmod a+x /data/www/scripts/*.sh