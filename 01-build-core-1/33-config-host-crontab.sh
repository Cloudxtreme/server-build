#!/bin/bash
### ****************************************************************************
###
### Replacement crontab file (start jobs earlier each day)
###
### ****************************************************************************

# overwrite existing crontab file
sudo mv /etc/crontab /etc/crontab.old
sudo cp ~/source/config/crontab/crontab /etc/crontab

# Commit to etckeeper
if [ -e ~/source/temp/etckeeper ]; then 
  sudo etckeeper commit "Adjust crontrab times"
fi