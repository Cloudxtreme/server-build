#!/bin/bash
### ****************************************************************************
###
### Set server to send email at startup/shutdown
###
### ****************************************************************************

sudo cp ~ubuntu/source/config/scripts/email-at-startup /etc/init.d/email-at-startup
sudo chmod +x /etc/init.d/email-at-startup
sudo update-rc.d email-at-startup defaults 85 15

# Commit to etckeeper
if [ -e ~ubuntu/source/temp/etckeeper ]; then 
  sudo etckeeper commit "Confiured server to send mail on startup/shudown"
fi