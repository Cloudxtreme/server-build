#!/bin/bash
### ****************************************************************************
###
### Download source files from GitHub private repo
###
### Requires:
###  - an auth token with access to GitHub
###
### ****************************************************************************

# check for github auth token
#if [ -z ${__GITHUBAUTHTOKEN+x} ]; then
#	echo "ERROR: No GitHub auth token found"
#	return;
#fi

# Create build location
mkdir /var/tmp/server-build
sudo chown root:adm /var/tmp/server-build
sudo chmod g+rwxs /var/tmp/server-build

# Download source files from GitHub
#curl --progress-bar --header "Authorization: token {__GITHUBAUTHTOKEN}" \
#  --location --url "https://api.github.com/repos/danielmerriott/server-build/tarball/master" \
#  --output /var/tmp/server-build/source.tar.gz
curl --progress-bar --location \
     --url "https://api.github.com/repos/danielmerriott/server-build/tarball/master" \
     --output /var/tmp/server-build/source.tar.gz

# Extract into /var/tmp/server-build/source
rm -rf /var/tmp/server-build/source
tar --gzip --extract --file /var/tmp/server-build/source.tar.gz --directory /var/tmp/server-build --transform 's;/*[^/]*;source/;'
# Remove tarball
rm /var/tmp/server-build/source.tar.gz
# Make build files executable
find /var/tmp/server-build/source -type f -name "*.sh" -exec chmod +x {} \;
