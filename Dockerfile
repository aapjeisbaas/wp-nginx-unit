FROM nginx/unit:1.25.0-php8.0
RUN curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd opcache intl mysqli zip bcmath imagick exif mcrypt bz2 calendar ctype curl date dom zlib zip xsl xmlwriter xmlreader xml tokenizer tidy spl soap simplexml session reflection pspell posix phar pdo_sqlite sqlite3 pdo_mysql pdo pcre openssl mysqlnd mysqli mbstring libxml json intl imap iconv hash gettext ftp filter fileinfo exif dom date curl ctype
COPY config.json /docker-entrypoint.d/ 
