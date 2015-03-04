#!/bin/bash
### ****************************************************************************
###
### Restart
###
### ****************************************************************************

echo -e "\n\nThe system will now schedule a reboot.\n\n" \
        "Please be sure to ssh on to the system using the\n" \
        "new user details (not 'ubuntu') to proceed.\n\n"

sudo shutdown -r +1