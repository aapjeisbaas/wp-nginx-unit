FROM nginx/unit:1.25.0-php8.0
RUN curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions bcmath bz2 calendar core ctype curl date dom exif fileinfo filter ftp gd gettext hash iconv imagick imap intl json libxml mbstring mcrypt mysqli mysqlnd opcache openssl pcre pdo pdo_mysql pdo_sqlite phar posix pspell reflection session simplexml soap sodium spl sqlite3 standard tidy tokenizer xml xmlreader xmlwriter xsl zend+opcache zip zlib
COPY config.json /docker-entrypoint.d/ 
