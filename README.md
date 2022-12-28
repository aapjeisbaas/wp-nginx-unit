## wp-nginx-unit
A stripped down minimal wordpress runtime, just mount your wordpress dir in `/var/www` and connect port 8080 to your load balancer.

## install
This container does not ship with wordpress itself, it's just a compatible runtime so to get started we need to follow some setup steps.
1. Get the latest wordpress `wget https://wordpress.org/latest.tar.gz`
2. Extract it `tar -xvf latest.tar.gz`
3. Change file ownership `sudo chown -R 101:101 wordpress`
4. Prepare a database and a database user
```
CREATE DATABASE wordpress;
CREATE USER 'wordpress'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'%';
FLUSH PRIVILEGES;
```
5. Run the container
```
sudo docker run -p 8080:8080 -v "$PWD/wordpress":/var/www registry.gitlab.com/aapjeisbaas/wp-nginx-unit:latest
```

## Boost performance
1. install [wp-super-cache](https://wordpress.org/plugins/wp-super-cache/)
2. Change cache path to: `/tmp/wpsupercache/` **This cache will be gone after every restart, as far as I can see this has no negative side effects but the local storage is often faster then shared storage.**
3. Set cache timeout to: `0`
4. Enable preload

## custom nginx unit config
If the default unit config isn't what you're looking for simply mount a different config file in place.
```
sudo docker run -p 8080:8080 -v "$PWD/config.json":/docker-entrypoint.d/config.json -v "$PWD/wordpress":/var/www registry.gitlab.com/aapjeisbaas/wp-nginx-unit:latest
```

## database
There is no database in this container image, use a sepperate mysql instance to store your data.

## php user
```
root@wordpress-deployment-75cf67fcd9-pbw24:/# id unit
uid=101(unit) gid=101(unit) groups=101(unit)
```


## magic juicy to fix https and domain in wp-config.php

```
define( 'WP_HOME', 'https://example.com' );
define( 'WP_SITEURL', 'https://example.com' );

// If we're behind a proxy server and using HTTPS, we need to alert Wordpress of that fact
// see also http://codex.wordpress.org/Administration_Over_SSL#Using_a_Reverse_Proxy
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
	$_SERVER['HTTPS'] = 'on';
}

```


## change site URL
> first change the wp-config.php url tot the new one.
```
# docs: https://developer.wordpress.org/cli/commands/search-replace/
# shell into the container and run

cd /var/www/ ; wp --allow-root search-replace 'https://dev.example.com' 'https://example.com' --skip-columns=guid
```