#!/bin/bash
### ****************************************************************************
###
### Setup data area
###
### ****************************************************************************

# Set permissions on /data
sudo chown root:root /data
sudo chmod 755 /data

# Create /var/www (required so we can setup /var/www/.gitconfig)
sudo mkdir /var/www
sudo chown --recursive www-data:www-data /var/www
sudo chmod --recursive 2775 /data

# Create /backups
sudo mkdir /backups
sudo chown --recursive root:backup /backups
sudo chmod --recursive 2775 /backups