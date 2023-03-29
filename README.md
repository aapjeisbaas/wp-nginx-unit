## wp-nginx-unit
A stripped down minimal wordpress runtime, just mount your wordpress dir in `/var/www` and connect port 8080 to your load balancer.

## install
This container downloads wordpress automaticly if none is found in `/var/www/` so you can simply run the container:
```
sudo docker run -p 8080:8080 -v "$PWD/wordpress":/var/www aapjeisbaas/wp-nginx-unit:latest
```

## database
There is no database in this container image, use a seperate mysql instance to store your data, a quick reminder for db + user creation in mysql:
```
CREATE DATABASE wordpress;
CREATE USER 'wordpress'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'%';
FLUSH PRIVILEGES;
```

## php user in this runtime
```
root@wordpress-deployment-75cf67fcd9-pbw24:/# id unit
uid=101(unit) gid=101(unit) groups=101(unit)
```


## magic fix your domain in wp-config.php

```
define( 'WP_HOME', 'https://example.com' );
define( 'WP_SITEURL', 'https://example.com' );
```

## change site URL using the wp cli
> first change the wp-config.php url tot the new one.
```
# docs: https://developer.wordpress.org/cli/commands/search-replace/
# shell into the container and run

cd /var/www/ ; wp --allow-root search-replace 'https://dev.example.com' 'https://example.com' --skip-columns=guid
```



## optimization
Post revisions
```
define( ‘WP_POST_REVISIONS’, false ); << wp-config.php

wp post list --post_type='revision' --format=ids

wp post delete $(wp post list --post_type='revision' --format=ids)
```

Cron jobs (cron runs every 50 seconds automatically)
```
# disable cron triggers from http requests
define( 'DISABLE_WP_CRON', true );
```

