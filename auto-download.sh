#!/bin/bash

curl_put()
{
    RET=$(/usr/bin/curl -s -w '%{http_code}' -X PUT --data-binary @$1 --unix-socket /var/run/control.unit.sock http://localhost/$2)
    RET_BODY=$(echo $RET | /bin/sed '$ s/...$//')
    RET_STATUS=$(echo $RET | /usr/bin/tail -c 4)
    if [ "$RET_STATUS" -ne "200" ]; then
        echo "$0: Error: HTTP response status code is '$RET_STATUS'"
        echo "$RET_BODY"
        return 1
    else
        echo "$0: OK: HTTP response status code is '$RET_STATUS'"
        echo "$RET_BODY"
    fi
    return 0
}

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


curl_put /config.json "config"