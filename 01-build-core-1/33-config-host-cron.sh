#!/bin/bash
### ****************************************************************************
###
### Replacement crontab file (start jobs earlier each day)
###
### ****************************************************************************

# enable seperate logging of cron jobs
sudo sed -i '/^#cron\./{s/^#//}' /etc/rsyslog.d/50-default.conf

# Commit to etckeeper
if [ -e ~/source/temp/etckeeper ]; then 
  sudo etckeeper commit "Adjust cron config"
fi