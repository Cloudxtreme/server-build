#!/bin/bash
### ****************************************************************************
###
### Record the keys, etc, for later use
###
### ****************************************************************************

echo "#!/bin/bash" > /var/tmp/server-build/keys.sh

### GitHub Auth Token for downloading files
#
echo export __GITHUBAUTHTOKEN=\"${__GITHUBAUTHTOKEN}\" >> /var/tmp/server-build/keys.sh

### Authy API Key
#
echo export __AUTHYAPIKEY=\"${__AUTHYAPIKEY}\" >> /var/tmp/server-build/keys.sh

### Log Entries Account Key for configuring logentries
#
echo export __LOGENTRIESACCTKEY=\"${__LOGENTRIESACCTKEY}\" >> /var/tmp/server-build/keys.sh

### Pushover email api key
#
echo export __PUSHOVEREMAILAPIKEY=\"${__PUSHOVEREMAILAPIKEY}\" >> /var/tmp/server-build/keys.sh