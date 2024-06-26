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

# start backgroud cron runner within a minute of starting the container
# random start moment to reduce cron run collisions on larger deployments 
while true; do sleep $((1 + RANDOM % 20));  wp --path="/var/www/" --allow-root cron event run --due-now --no-color | grep -ve 'Success: Executed a total of';sleep 35; done&

# make sure files are always owned by unit
# run chown now in the background
`find /var/www -not -user unit -execdir chown unit:unit {} \+`&
# run chown at least once every 10 hours in the background
while true; do sleep $((1 + RANDOM % 36000)); find /var/www -not -user unit -execdir chown unit:unit {} \+ ; done&
