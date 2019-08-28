FROM alpine:edge
MAINTAINER Zhizuzhefu <i@mail.chenpeng.info>

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# dependencies required for running "phpize"
ENV PHPIZE_DEPS \
    autoconf \
    dpkg-dev dpkg \
    file \
    g++ \
    gcc \
    libc-dev \
    make \
    pkgconf \
    libtool \
    re2c \
    automake

RUN set -ex \
    && apk update \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && apk add --no-cache --virtual .runtime-deps \
        ca-certificates \
        pcre \
        tzdata \
        php7 \
        php7-dev \
        php7-pear \
        curl \
    && php -v

RUN set -ex \
    && apk update \
    && apk add --no-cache \
        php7-json \
        php7-iconv \
        php7-ctype \
        php7-openssl \
        php7-phar \
        php7-bcmath \
        php7-curl \
        php7-dom \
        php7-mbstring \
        php7-pcntl \
        php7-mysqli \
        php7-memcached \
        php7-pdo \
        php7-pdo_mysql \
        php7-pdo_sqlite \
        php7-pdo_odbc \
        php7-posix \
        php7-redis \
        php7-sockets \
        php7-session \
        php7-sodium \
        php7-sysvshm \
        php7-sysvmsg \
        php7-sysvsem \
        php7-zip \
        php7-bz2 \
        php7-zlib \
        php7-simplexml \
        php7-tokenizer \
        php7-fileinfo \
        php7-mcrypt \
        php7-opcache \
        php7-apcu \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN set -ex \
    && pecl install swoole \
    && echo 'extension=swoole.so' > /etc/php7/conf.d/30_swoole.ini \
    && echo 'swoole.use_shortname = "Off"' >> /etc/php7/conf.d/30_swoole.ini \
    && apk add --no-cache imagemagick-dev \
    && pecl install imagick \
    && echo 'extension=imagick.so' > /etc/php7/conf.d/30_imagick.ini \
    && apk del .build-deps \
    && rm -rf /tmp/* /var/cache/apk/* \
    && php --ini

WORKDIR /app

CMD ["php", "-a"]

# docker build --rm -t zhizuzhefu/php:7.3-cli .
# docker run -it --rm --net=host --name php-cli -v "$PWD":/app -w /app zhizuzhefu/php:7.3-cli php -m
# docker run -it --rm zhizuzhefu/php:7.3-cli /bin/sh
