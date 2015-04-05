#!/bin/bash
### ****************************************************************************
###
### Install Postfix Mail Server
###
### Assumes:
###  - Appropriate DNSHOSTNAME has been configured
###  - Mail hostname should be mail.CLOUDNAME.openleaf.ws
###  & Mail domain name should be CLOUDNAME.openleaf.ws
###    (where CLOUDNAME is the last part of DNSHOSTNAME)
###  - DNS is already setup correctly
###
### ****************************************************************************

# check for pushover email api key
if [ -z ${__PUSHOVEREMAILAPIKEY+x} ]; then
	echo "ERROR: No Pushover Email API Key found"
	return;
fi

# Setup 'DNSHOSTNAME' variable (see config/etc-profile/7x-xxx-profile.sh)
if [ -e /var/tmp/server-build/cloudprofile ]; then 
  for f in $(</var/tmp/server-build/cloudprofile)
  do
    . /var/tmp/server-build/source/config/etc-profile/${f}
  done
  unset f
fi

### Set up debconf answer files and install

# set the type of server to 'Internet' (send/receive SMTP)
sudo bash -c "echo postfix postfix/main_mailer_type string Internet Site | debconf-set-selections"

# set the domain name used to qualify all mail addresses without a domain
sudo bash -c "echo postfix postfix/mailname string ${DNSHOSTNAME}.openleaf.ws | debconf-set-selections"

# set domain name(s) to receive mail for
sudo bash -c "echo postfix postfix/destinations string ${DNSHOSTNAME##*.}.openleaf.ws | debconf-set-selections"

# install postfix & basic mail utilities
sudo apt-get install postfix mailutils --assume-yes

# stop mail services
sudo service postfix stop

### Essential Configuration

# hostname, domainname, origin (/etc/mailname), masquerade
sudo postconf -e myhostname=mail.${DNSHOSTNAME##*.}.openleaf.ws
sudo postconf -e mydomain=${DNSHOSTNAME##*.}.openleaf.ws
sudo postconf -e myorigin=${DNSHOSTNAME}.openleaf.ws
sudo sed -i "s/^.*$/${DNSHOSTNAME}.openleaf.ws/" /etc/mailname
sudo postconf -e masquerade_domains=${DNSHOSTNAME##*.}.openleaf.ws

# append mydomain where needed
sudo postconf -e append_dot_mydomain=yes

# set local domains (debconf doesn't get this right)
sudo postconf -e mydestination="${DNSHOSTNAME##*.}.openleaf.ws, ${DNSHOSTNAME}.openleaf.ws, ${DNSHOSTNAME}, localhost"

# use long queue IDs (removes date from msgid)
sudo postconf -e enable_long_queue_ids=yes

# disable TLS until we have a valid certificate
sudo postconf -e smtpd_use_tls='no'

# Only supply minimum information in the SMTP banner - defaults to $myhostname ESMTP $mail_name (Ubuntu)
sudo postconf -e smtpd_banner='$myhostname ESMTP $mail_name'

# Shorten the warning for delayed mail
sudo postconf -e delay_warning_time=1h
sudo sed -i "s/^[#]*delay_warning_time.*$/delay_warning_time = 1h/" /etc/postfix/main.cf

# Additional error reporting to postmaster (default is only 'resource, software')
sudo postconf -e notify_classes='resource, software, bounce, 2bounce, delay, policy, protocol'

# Drop the 'crap' from start of config file
sudo sed -i '/^# Debian specific:.*/d' /etc/postfix/main.cf
sudo sed -i '/^# line of that file to be.*/d' /etc/postfix/main.cf
sudo sed -i '/^# is \/etc\/mailname.*/d' /etc/postfix/main.cf
sudo sed -i '/^#myorigin = \/etc\/mailname.*/d' /etc/postfix/main.cf

# Redirect mail
printf "%-15s%s\n" ubuntu: root | sudo tee -a /etc/aliases
printf "%-15s%s\n" $HOSTNAME: root | sudo tee -a /etc/aliases
printf "%-15s%s\n" root: \\root,hostmaster@openleaf.ws | sudo tee -a /etc/aliases
printf "%-15s%s\n" pushover: ${__PUSHOVEREMAILAPIKEY}@api.pushover.net | sudo tee -a /etc/aliases
sudo newaliases

# reload config
sudo postfix start

# Add logs to log entries agent
if [ -e /var/tmp/server-build/logentries ]; then 
  sudo le follow "/var/log/mail.*" --name=mail
  sudo service logentries restart
fi

# Commit to etckeeper
if [ -e /var/tmp/server-build/etckeeper ]; then 
  sudo etckeeper commit "Installed Postfix mail server "
fi

# CONFIG NOTES
# https://help.ubuntu.com/community/Postfix
# http://www.postfix.org/postconf.5.html
# http://www.postfix.org/BASIC_CONFIGURATION_README.html
# http://www.postfix.org/documentation.html
# http://help.ubuntu.com/community/PostfixBasicSetupHowto