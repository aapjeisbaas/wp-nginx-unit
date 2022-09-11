#!/bin/bash

# download fresh wordpress is /var/www/index.php does not exist.
if [ ! -f "/var/www/index.php" ]; then
    echo "Downloading latest wordpress"
    curl -o /tmp/latest.tar.gz  https://wordpress.org/latest.tar.gz
    tar -xf /tmp/latest.tar.gz -C /tmp/
    mv /tmp/wordpress/* /var/www
    chown -R unit:unit /var/www
else
    echo "Not downloading wordpress, found an index.php file in /var/www/"
fi
