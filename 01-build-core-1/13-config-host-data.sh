#!/bin/bash
### ****************************************************************************
###
### Setup data area
###
### ****************************************************************************

# Set permissions on /data
sudo chown root:root /data
sudo chmod 755 /data

# Create /backups
sudo mkdir /backups
sudo chown --recursive root:backup /backups
sudo chmod --recursive 2775 /backups