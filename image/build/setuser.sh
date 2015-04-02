#!/bin/bash

# Set the nginx user and group to match the host user.
OWNER=$(stat -c '%u' /var/www)
GROUP=$(stat -c '%g' /var/www)
echo "Setting uid to $OWNER and gid to $GROUP for user www-data"
usermod -o -u $OWNER www-data
groupmod -o -g $GROUP www-data
