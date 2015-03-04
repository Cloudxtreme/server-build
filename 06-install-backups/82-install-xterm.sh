#!/bin/bash
### ****************************************************************************
###
### Install XTerm Support
###
### ****************************************************************************

sudo apt-get install xterm libswt-gtk-3-java

# ssh config
sudo sed -i "s/^[ \t]*ForwardAgent.*/ForwardAgent yes/" /etc/ssh/ssh_config
sudo sed -i "s/^[ \t]*ForwardX11Trusted.*/ForwardX11Trusted yes/" /etc/ssh/ssh_config
sudo sed -i "s/^[ \t]*ForwardX11[ \t].*/ForwardX11 yes/" /etc/ssh/ssh_config

# sshd config
sudo sed -i "s/^[ \t]*X11Forwarding.*/X11Forwarding yes/" /etc/ssh/sshd_config

# Commit to etckeeper
if [ -e ~ubuntu/source/temp/etckeeper ]; then 
  sudo etckeeper commit "Installed Basic XTerm Capabilities (for CrashPlan)"
fi