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
if [ -z ${__GITHUBAUTHTOKEN+x} ]; then
	echo "ERROR: No GitHub auth token found"
	return;
fi


# Download source files from GitHub
#curl --progress-bar --header "Authorization: token {__GITHUBAUTHTOKEN}" \
#  --location --url "https://api.github.com/repos/danielmerriott/server-build/tarball/master" \
#  --output ~/source.tar.gz
curl --progress-bar --location
     --url "https://api.github.com/repos/danielmerriott/server-build/tarball/master" \
     --output ~/source.tar.gz  

# Extract into ~/source
rm -rf ~/source
tar --gzip --extract --file source.tar.gz --directory ~ --transform 's;/*[^/]*;source/;'
# Remove tarball
rm ~/source.tar.gz
# Make build files executable
find ~/source -type f -name "*.sh" -exec chmod +x {} \;
# Crete temp area
mkdir ~/source/temp