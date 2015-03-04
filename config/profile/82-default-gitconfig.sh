# Openleaf custom changes

# Setup a sensible .gitconfig file for the user if git is installed and ~/.gitconfig doesn't already exist
if [ "$BASH" ] && [ "$BASH" != "/bin/sh" ]; then
	if which git &>/dev/null; then
	  if [ ! -f "~/.gitconfig" ]; then
	    git config --global user.name "${USERNAME:-${USER^}}"
	    git config --global user.email "${USER}@${DNSHOSTNAME:-$HOSTNAME.cloud}"
	  fi
	fi
fi