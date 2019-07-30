FROM php:7.2-fpm

# Update packages and install composer and PHP dependencies.
RUN apt-get update && apt-get install -y \
    build-essential \
    zip \
    unzip \
    git \
    curl \
    nginx

# PHP Extensions
RUN docker-php-ext-install mbstring pdo pdo_mysql

RUN apt-get install supervisor net-tools vim nano -y

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Node.js
RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs -y
RUN npm install npm@6.9.0 -g

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./docker/nginx/default-prod.conf /etc/nginx/conf.d/default.conf
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY . /var/www/html
RUN usermod -u 1000 www-data
WORKDIR /var/www/html

# RUN chown -R $USER:www-data storage
# RUN chown -R $USER:www-data bootstrap/cache

RUN composer install --no-interaction --no-dev --prefer-dist
RUN npm install && npm run prod

RUN bash -c "rm -rf node_modules && rm -rf index.nginx-debian.html"

RUN cp .env.example .env && php artisan key:generate

# RUN chmod -R 775 storage
# RUN chmod -R 775 bootstrap/cache

CMD ["/usr/bin/supervisord"]
# RUN nginx

EXPOSE 80