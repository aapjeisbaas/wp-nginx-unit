#!/bin/bash

echo "Downloading latest wordpress"

# check if /var/www has files
if [ ! -f "/var/www/index.php" ]; then
    curl -o /tmp/latest.tar.gz  https://wordpress.org/latest.tar.gz
    tar -xf /tmp/latest.tar.gz -C /tmp/
    mv /tmp/wordpress/* /var/www
    chown -R unit:unit /var/www
fi
