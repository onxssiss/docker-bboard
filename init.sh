#!/bin/bash

echo 'Waiting for Mysql to be available'
maxTries=10
while [ ${maxTries} -gt 0 ] && ! mysql --user=${DB_USERNAME} --password=${DB_PASSWORD} --host=${DB_HOST} --port=${DB_PORT} --database=${DB_DATABASE} -e exit; do
    sleep 15
done

php artisan migrate --force
./usr/local/sbin/php-fpm && nginx -g "daemon off;"