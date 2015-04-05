#!/bin/bash
### ****************************************************************************
###
### Install PHPMyAdmin
###
### ****************************************************************************

# use the ppa:nijel for phpmyadmin to get the latest available
sudo add-apt-repository ppa:nijel/phpmyadmin --yes
sudo apt-key update
sudo apt-get update

### see http://stackoverflow.com/questions/22440298/preseeding-phpmyadmin-skip-multiselect-skip-password
### see http://paynedigital.com/articles/2011/09/setting-up-and-securing-a-phpmyadmin-install-on-ubuntu-10-04

# create a password for the PMA user
# we will also use this as a temporary password for mysql root user
# because the password is stored in the debconf database
# /var/cache/debconf/passwords.dat (file is rw to root user only)
PMAUSER_PASS=$(pwgen -1asc 23)

# change the root user password to the temporary password as we need to specify it
echo "update mysql.user set password=PASSWORD('${PMAUSER_PASS}') where user='root'; flush privileges;" | sudo mysql --defaults-file=/etc/mysql/debian.cnf

# set up debconf answer files for quiet phpmyadmin install
sudo bash -c 'echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections'
sudo bash -c 'echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections'
sudo bash -c 'echo "phpmyadmin phpmyadmin/mysql/admin-user string root" | debconf-set-selections'
sudo env PMAUSER_PASS=$PMAUSER_PASS bash -c 'echo "phpmyadmin phpmyadmin/mysql/admin-pass password ${PMAUSER_PASS}" | debconf-set-selections'
sudo env PMAUSER_PASS=$PMAUSER_PASS bash -c 'echo "phpmyadmin phpmyadmin/mysql/app-pass password ${PMAUSER_PASS}" |debconf-set-selections'
sudo env PMAUSER_PASS=$PMAUSER_PASS bash -c 'echo "phpmyadmin phpmyadmin/app-password-confirm password ${PMAUSER_PASS}" | debconf-set-selections'

# install phpmyadmin
sudo apt-get install phpmyadmin --assume-yes

# php5enmod needs to be activated manually
sudo php5enmod mcrypt

# unload the phpmyadmin config (this adds '/phpmyadmin' to every site!)
# sites that need it can simply include the file or a more secure version in their config
sudo a2disconf phpmyadmin

# reload apache
sudo service apache2 reload

# change the root user password (again)
NEWMYSQLROOTPWD=$(pwgen -1asc 31)
echo "update mysql.user set password=PASSWORD('${NEWMYSQLROOTPWD}') where user='root'; flush privileges;" | sudo mysql --defaults-file=/etc/mysql/debian.cnf

# (re)configure password-less access to mysql for root
touch /var/tmp/server-build/mysql-root-access
cat >/var/tmp/server-build/mysql-root-access <<EOL
[client]
host=localhost
password="${NEWMYSQLROOTPWD}"
user="root"
EOL
sudo cp /var/tmp/server-build/mysql-root-access /root/.my.cnf
sudo chmod 600 /root/.my.cnf
sudo shred --force --zero /var/tmp/server-build/mysql-root-access
unset NEWMYSQLROOTPWD

# Commit to etckeeper
if [ -e /var/tmp/server-build/etckeeper ]; then 
  sudo etckeeper commit "Installed PHPMyAdmin"
fi
