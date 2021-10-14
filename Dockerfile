FROM nginx/unit:1.25.0-php8.0
RUN curl -sSLf \
        -o /usr/local/bin/install-php-extensions \
        https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd opcache intl mysqli zip bcmath imagick exif mcrypt
COPY config.json /docker-entrypoint.d/ 
