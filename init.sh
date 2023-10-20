#!/bin/bash

# This script sets the appropriate user permissions for various files and directories.

# Define the users and groups
USER_IC="ic"
GROUP_IC="ic"
USER_WWW_DATA="www-data"
GROUP_WWW_DATA="www-data"

# Verify that the script is running as root, otherwise it may not have permission to change ownership
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Change ownership of all files and directories in the current directory to 'ic' user and group
chown -R "${USER_IC}:${GROUP_IC}" .

# Change ownership of 'storage/' directory to 'www-data' user and group for web server access
chown -R "${USER_WWW_DATA}:${GROUP_WWW_DATA}" storage/

# Ensure the versions file exists and is owned by 'ic' user
touch storage/app/public/versions.txt
chown "${USER_IC}:${GROUP_IC}" storage/app/public/versions.txt

# Make scripts executable
chmod u+x start.sh
chmod u+x update.sh

echo "User permissions have been set."
