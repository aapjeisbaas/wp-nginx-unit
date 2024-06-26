FROM unit:1.30.0-php8.2
RUN curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions bcmath bz2 calendar core ctype curl date dom exif fileinfo filter ftp gd gettext hash iconv imagick imap intl json libxml mbstring mcrypt mysqli mysqlnd opcache openssl pcre pdo pdo_mysql pdo_sqlite phar posix pspell reflection session simplexml soap sodium spl sqlite3 standard tidy tokenizer xml xmlreader xmlwriter xsl zip zlib memcached apcu redis && \
    curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp
COPY config.json /
COPY auto-download.sh /docker-entrypoint.d/ 