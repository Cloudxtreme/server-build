#!/bin/bash
### ****************************************************************************
###
### Install apache scripts
###
### ****************************************************************************

sudo mkdir /data/www/scripts
sudo cp --recursive ~ubuntu/source/config/apache-scripts/* /data/www/scripts
sudo chmod a+x /data/www/scripts/*.sh