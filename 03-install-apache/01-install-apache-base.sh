#!/bin/bash
### ****************************************************************************
###
### Install and configure base apache installation with PHP5-FPM
###
### ****************************************************************************

# Setup /data/www
sudo mkdir /data/www
sudo chown www-data:www-data /data/www
sudo chmod 2775 /data/www

# Setup /var/www
sudo mkdir --parents /var/www
sudo chown www-data:www-data /var/www
sudo chmod 2755 /var/www

#### may need to get apache dev tools (to get apxs2) before we mess about with repos
sudo apt-get install apache2-dev --assume-yes

# use the ppa:ondrej for apache2 and php5 to get the latest available
sudo add-apt-repository ppa:ondrej/apache2 --yes
sudo add-apt-repository ppa:ondrej/php5-5.6 --yes
sudo apt-key update

# upgrade any existing packages
sudo apt-get upgrade --assume-yes

# enable access to existing multiverse packages for libapache2-mod-fastcgi
# quick-way is sudo apt-add-repository multiverse
sudo sed -i "/^# deb .*$(lsb_release --short --codename) multiverse/ s/^# //" /etc/apt/sources.list
sudo sed -i "/^# deb .*$(lsb_release --short --codename)-updates multiverse/ s/^# //" /etc/apt/sources.list

# update package lists
sudo apt-get update

# install apache, php5-fpm
sudo apt-get install apache2-mpm-event php5-fpm libapache2-mod-fastcgi --assume-yes

# install other apache/php related packages
sudo apt-get install php5-mcrypt php5-curl php5-gd libgd-tools php5-tidy php5-json php5-mysql --assume-yes

# disable multiverse (but keep updates available)
sudo sed -i "/^deb .*$(lsb_release --short --codename) multiverse/ s/^/### /" /etc/apt/sources.list

# set timezone and other settings in php.ini files
for f in $(find /etc/php5 -name php.ini)
do
	sudo sed -i "s,^[ \t]*[;]*[ ]*date\.timezone.*,date\.timezone = $(cat /etc/timezone)," $f
	sudo sed -i "s,^[ \t]*[;]*[ ]*upload_max_filesize.*,upload_max_filesize = 60M," $f
	sudo sed -i "s,^[ \t]*[;]*[ ]*expose_php.*,expose_php = Off," $f
	sudo sed -i "s,^[ \t]*[;]*[ ]*allow_url_fopen.*,allow_url_fopen = Off," $f
	sudo sed -i "s,^[ \t]*[;]*[ ]*allow_url_include.*,allow_url_include = Off," $f
done
unset f

# copy in reource files and link to /etc/apache
sudo cp ~ubuntu/source/config/apache-conf/*.conf /etc/apache2/conf-available

# Apache config
for f in ~ubuntu/source/config/apache-conf/*.conf
do
	sudo a2enconf --quiet $(basename $f .conf)
done
unset f

# specific Apache modules
sudo a2dismod --quiet php5 mpm_prefork proxy_fcgi proxy
sudo a2enmod --quiet ssl vhost_alias rewrite headers expires filter actions fastcgi alias mpm_event

# Stop Apache
sudo service apache2 stop

# Set UMASK for Apache
### is this necessary now? Could this do in the php5-fpm config?
echo -e "\n# set UMASK so group has write access\numask 0002" | sudo tee -a /etc/apache2/envvars

# Remote existing sites
sudo rm -rf /etc/apache2/sites-enabled/*

# Rename the default sites
for f in /etc/apache2/sites-available/*.conf
do
	sudo mv "/etc/apache2/sites-available/$(basename $f)" "/etc/apache2/sites-available/$(basename $f .conf).orig"
done
unset f

# Set a default servername
echo ServerName ${DNSHOSTNAME:-$HOSTNAME.cloud} | sudo tee /etc/apache2/conf-available/servername.conf
sudo a2enconf servername

# Remove default vhost logging
sudo a2disconf --quiet other-vhosts-access-log

# Remove default CGI-BIN support
sudo a2disconf --quiet serve-cgi-bin

# Unlink and copy the default security file so we can edit it
sudo a2disconf --quiet security
sudo cp /etc/apache2/conf-available/security.conf /etc/apache2/conf-available/security.orig
# reduce ServerTokens 
sudo sed -i "s/^[ \t]*ServerTokens Full.*/#ServerTokens Full/" /etc/apache2/conf-available/security.conf
sudo sed -i "s/^[ \t]*ServerTokens OS.*/#ServerTokens OS/" /etc/apache2/conf-available/security.conf
sudo sed -i "s/^[ \t]*ServerTokens Min[imal].*/#ServerTokens Minimal/" /etc/apache2/conf-available/security.conf
sudo sed -i "s/^[ \t]*ServerTokens Minor.*/#ServerTokens Minor/" /etc/apache2/conf-available/security.conf
sudo sed -i "s/^[ \t]*ServerTokens Major.*/#ServerTokens Major/" /etc/apache2/conf-available/security.conf
sudo sed -i "s/^[ \t]*ServerTokens Prod[uctOnly].*/#ServerTokens ProductOnly/" /etc/apache2/conf-available/security.conf
sudo sed -i "s/^[ \t]*#*[ \t]*ServerTokens Minor.*/ServerTokens Minor/" /etc/apache2/conf-available/security.conf
# check for the ServerTokens Minor string, replace the first ServerTokens if needed
if ! grep -q "^ServerTokens Minor" /etc/apache2/conf-available/security.conf; then
	sudo sed -i "1,/^[ \t]*#*[ \t]*ServerTokens[ \t]*[A-Za-z].*/s/^[ \t]*#*[ \t]*ServerTokens[ \t]*[A-Za-z].*/ServerTokens Minor/" /etc/apache2/conf-available/security.conf
fi
# Remove the Server Signature
sudo sed -i "s/^[ \t]*ServerSignature On.*/#ServerSignature On/" /etc/apache2/conf-available/security.conf
sudo sed -i "s/^[ \t]*#ServerSignature Off.*/ServerSignature Off/" /etc/apache2/conf-available/security.conf
# Relink security.conf
sudo a2enconf --quiet security

# Disable default PHP5-FPM config file
##sudo mv /etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.orig

# Configure test site
sudo cp --recursive ~ubuntu/source/config/apache-testsite /data/www/testsite
sudo ln -s /data/www/testsite/config/999-test-apache.conf /etc/apache2/sites-available/999-testsite-test.conf
##sudo ln -s /data/www/testsite/config/999-phpfpm.conf /etc/php5/fpm/pool.d/999-testsite.conf
sudo a2ensite 999-testsite-test

# Add the additional logs config to logrotate
sudo cp --recursive ~ubuntu/source/config/apache-logrotate /etc/logrotate.d

# Finally, restart apache and fpm
sudo service php5-fpm restart
sudo service apache2 restart

# Add  logs to logentries agent
if [ -e /var/tmp/server-build/logentries ]; then 
  sudo le follow "/var/log/apache2/*.log" --name=apache
  sudo le follow "/data/www/*/logs/*.log" --name=apache-hosts
  sudo le follow "/var/log/php5-fpm*.log" --name=apache-php
  sudo service logentries restart
fi

# Commit to etckeeper
if [ -e /var/tmp/server-build/etckeeper ]; then 
  sudo etckeeper commit "Installed and configured Apache with PHP5-FPM"
fi