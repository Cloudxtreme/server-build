#!/bin/bash
### ****************************************************************************
###
### Configure SSH Server
###
### Assumes:
###  - OpenSSH is already installed
###
### ****************************************************************************

### Edits

# Verbose logging (make sure failed attempts are logged)
sudo sed -i "s/^[ \t]*LogLevel.*/LogLevel VERBOSE/" /etc/ssh/sshd_config

# Ensure root login via SSH is denied
sudo sed -i "s/^[ \t]*PermitRootLogin.*/PermitRootLogin no/" /etc/ssh/sshd_config

# Ensure password based authentication is denied
sudo sed -i "s/^[ \t]*PasswordAuthentication.*/PasswordAuthentication no/" /etc/ssh/sshd_config

# Use Protocol 2
sudo sed -i "s/^[ \t]*Protocol.*/Protocol 2/" /etc/ssh/sshd_config

# Ensure Privilege Seperation and StrictModes
sudo sed -i "s/^[ \t]*UsePrivilegeSeparation.*/UsePrivilegeSeparation yes/" /etc/ssh/sshd_config

# Ensure StrictModes
sudo sed -i "s/^[ \t]*StrictModes.*/StrictModes yes/" /etc/ssh/sshd_config

# Ensure RSA and Pubkey based authentication is allowed
sudo sed -i "s/^[ \t]*RSAAuthentication.*/RSAAuthentication yes/" /etc/ssh/sshd_config
sudo sed -i "s/^[ \t]*PubkeyAuthentication.*/PubkeyAuthentication yes/" /etc/ssh/sshd_config

### Appends

# Disable DNS lookup on incoming connections
sudo sed -i '$a\\n\# DNS Lookup On Incoming Connections\nUseDNS no' /etc/ssh/sshd_config

# Choose specific Ciphers
sudo sed -i '$a\\n\# Ciphers\nCiphers aes128-ctr,aes256-ctr,arcfour256,aes128-cbc,aes256-cbc' /etc/ssh/sshd_config

# Enable group based access control
sudo sed -i '$a\\n\# Group Based Access Control\nAllowGroups sshlogin' /etc/ssh/sshd_config

# Create the sshlogin group
sudo addgroup --system sshlogin
sudo gpasswd --add ubuntu sshlogin

# Commit to etckeeper
if [ -e ~/source/temp/etckeeper ]; then 
  sudo etckeeper commit "Configure SSH Server"
fi