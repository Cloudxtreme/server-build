# Openleaf custom changes

# WEBDRIVE environment variables
export INSTANCEID="$(hostname)"
export LOCALIP="$(ip route get 8.8.8.8 | awk '{print $NF; exit}')"
export PUBLICIP="$(dig +short myip.opendns.com @resolver1.opendns.com)"
export DNSHOSTNAME="$(hostname).wd"
export HOSTLOCATION="WD/auckland"