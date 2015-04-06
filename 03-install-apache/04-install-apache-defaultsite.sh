#!/bin/bash
### ****************************************************************************
###
### Setup test / default site for Apache
###
### ****************************************************************************

# Copy in files
sudo cp --recursive /var/tmp/server-build/source/config/apache-default-site /data/www/default-site
sudo chown --recursive www-data:www-data /data/www/default-site

# link the config file and enable it
sudo ln -s /data/www/default-site/config/999-default-site-apache.conf /etc/apache2/sites-available/999-default-site.conf
sudo a2ensite 999-default-site
