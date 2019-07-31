#! /bin/bash

echo 'Waiting for Mysql to be available'
maxTries=10
while [ ${maxTries} -gt 0 ] && ! mysql -h ${DB_HOST} -P ${DB_PORT} -u ${DB_USERNAME} -p${DB_PASSWORD} -e exit; do
    sleep 15
done

php artisan migrate --force
./usr/local/sbin/php-fpm && nginx -g "daemon off;"