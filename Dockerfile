FROM ubuntu:18.04

WORKDIR /var/www

RUN export LC_ALL=C.UTF-8
RUN DEBIAN_FRONTEND=noninteractive
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update -y && apt-get -qq -y install \
    sudo \
    autoconf \
    autogen \
    language-pack-en-base \
    wget \
    zip \
    unzip \
    nginx \
    curl \
    git \
    build-essential \
    software-properties-common


# PHP
RUN add-apt-repository ppa:ondrej/php && apt-get update && apt-get install -y php7.2 php7.2-fpm
RUN apt-get install -y \
    php7.2-curl \
    php7.2-gd \
    php7.2-dev \
    php7.2-xml \
    php7.2-bcmath \
    php7.2-mysql \
    php7.2-pgsql \
    php7.2-mbstring \
    php7.2-zip \
    php7.2-bz2 \
    php7.2-sqlite \
    php7.2-soap \
    php7.2-json \
    php7.2-intl \
    php7.2-imap \
    php7.2-imagick \
    php7.2-common \
    php-memcached


# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs \
    && npm install npm@6.9.0 -g

COPY . .

RUN composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev

RUN npm install \
    && npm run production

RUN chown -R $USER:www-data \
    /var/www/storage \
    /var/www/bootstrap/cache \
    && chmod -R 775 storage \
    && chmod -R 775 bootstrap/cache

EXPOSE 80

COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

CMD [ "bash", "post-install.sh" ]