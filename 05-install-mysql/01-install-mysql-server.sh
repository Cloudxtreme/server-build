#!/bin/bash
### ****************************************************************************
###
### Install MySQL Server
###
### ****************************************************************************

# use the ppa:ondrej for mysql to get the latest available
sudo add-apt-repository ppa:ondrej/mysql-5.6 --yes
sudo apt-key update
sudo apt-get update

# Create a random password to be used during the MySQL install
# this gets stored in a file, so this must be changed straight away!
MYSQLROOTPWD=install-$(pwgen -1asc 19)

# set up debconf answer files for quiet mysql install
sudo env MYSQLROOTPWD=$MYSQLROOTPWD bash -c 'echo mysql-server-5.6 mysql-server/root_password password $MYSQLROOTPWD | debconf-set-selections'
sudo env MYSQLROOTPWD=$MYSQLROOTPWD bash -c 'echo mysql-server-5.6 mysql-server/root_password_again password $MYSQLROOTPWD | debconf-set-selections'

# Install mysql
sudo apt-get install mysql-server mysql-client --assume-yes

# Drop the anonymous user(s)
echo "drop from mysql.user where user=''; flush privileges;" | sudo mysql --defaults-file=/etc/mysql/debian.cnf

# change the MySQL root password
# note there are 3 root users by default so this has to be done by a sql query, not mysqladmin
NEWMYSQLROOTPWD=$(pwgen -1asc 31)
echo "update mysql.user set password=PASSWORD('${NEWMYSQLROOTPWD}') where user='root'; flush privileges;" | sudo mysql --defaults-file=/etc/mysql/debian.cnf

# Configure password-less access to mysql for root
touch ~ubuntu/source/temp/mysql-root-access
cat >~ubuntu/source/temp/mysql-root-access <<EOL
[client]
host=localhost
password="${NEWMYSQLROOTPWD}"
user="root"
EOL
sudo cp ~ubuntu/source/temp/mysql-root-access /root/.my.cnf
sudo chmod 600 /root/.my.cnf
sudo shred --force --zero ~ubuntu/source/temp/mysql-root-access
unset NEWMYSQLROOTPWD
# To use mysql client without any further prompts be sure to load the root user's home:
#   sudo -H mysql
# or run interactively from the root account via sudo -i
# or just use --defaults-file=/etc/mysql/debian.cnf

# Mysql config
sudo cp ~ubuntu/source/config/mysql-conf/*.cnf /etc/mysql/conf.d

# Setup /data/mysql
sudo mkdir /data/mysql
sudo chown mysql:mysql /data/mysql
sudo chmod 2775 /data/mysql

# Add logs to logentries agent
if [ -e ~ubuntu/source/temp/logentries ]; then 
  sudo le follow "/var/log/mysql*" --name=mysql
  sudo service logentries restart
fi

# Commit to etckeeper
if [ -e ~ubuntu/source/temp/etckeeper ]; then 
  sudo etckeeper commit "Installed MySQL server"
fi
