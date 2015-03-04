#!/bin/bash
### ****************************************************************************
###
### Install backup scripts and setup cron jobs
###
### Backup strategy:
###  - dump MYSQL database to file: /data/mysql/dbname.sql    EVERY 1 HOUR
###
###  - rdiff-backup /data/* to /backups/*                     EVERY 1 HOUR 
###  - rdiff-backup /home/* to /backups/home-*                EVERY 1 HOUR
###  - rdiff-backup /etc to /backups/etc                      EVERY 1 HOUR
###  - rdiff-backup /root to /backups/root                    EVERY 1 HOUR
###
###  - /backups to be sent to CrashPlan continuously          CONTINUOUSLY
###
### ****************************************************************************

# install the required tools
sudo apt-get install rdiff-backup --assume-yes

# copy the scripts
sudo mkdir /backups/scripts
sudo cp ~/ubuntu/source/config/backups-scripts/dumpmysql.sh /backups/scripts/dumpmysql.sh
sudo cp ~/ubuntu/source/config/backups-scripts/rdiffbackup.sh /backups/scripts/rdiffbackup.sh

# setup a crontab file in /etc/crontab.d
sudo cp ~/ubuntu/source/config/backups-conf/mybackups.cron /etc/cron.d/mybackups

# Commit to etckeeper
if [ -e ~ubuntu/source/temp/etckeeper ]; then 
  sudo etckeeper commit "Installed Backup Scripts"
fi