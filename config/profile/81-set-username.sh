# Openleaf custom changes

# Set a USERNAME variable (use the full name, or the username capitalized)
if [ "$BASH" ] && [ "$BASH" != "/bin/sh" ]; then
 	USERNAME=$(grep -i ^$USER /etc/passwd | cut -d: -f5)
	USERNAME="${USERNAME^}"
	export USERNAME="${USERNAME:-${USER^}}"
fi