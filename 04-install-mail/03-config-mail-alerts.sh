#!/bin/bash
### ****************************************************************************
###
### Set server to send email at startup/shutdown
###
### ****************************************************************************

sudo cp /var/tmp/server-build/source/config/mail-scripts/email-at-startup /etc/init.d/email-at-startup
sudo chmod +x /etc/init.d/email-at-startup
sudo update-rc.d email-at-startup defaults 85 15

# Commit to etckeeper
if [ -e /var/tmp/server-build/etckeeper ]; then 
  sudo etckeeper commit "Confiured server to send email on startup/shudown"
fi