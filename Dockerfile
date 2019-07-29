FROM php:7.2-fpm

# Update packages and install composer and PHP dependencies.
RUN apt-get update && apt-get install -y \
    build-essential \
    zip \
    unzip \
    git \
    curl

# PHP Extensions
RUN docker-php-ext-install mbstring pdo pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Node.js
RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs -y
RUN npm install npm@6.9.0 -g

COPY . /var/www/html
WORKDIR /var/www/html

RUN chown -R $USER:www-data storage
RUN chown -R $USER:www-data bootstrap/cache

RUN composer install --no-interaction --no-dev --prefer-dist
RUN npm install

RUN cp .env.example .env && php artisan key:generate

RUN chmod -R 775 storage
RUN chmod -R 775 bootstrap/cache