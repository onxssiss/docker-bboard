cp .env.example .env && php artisan key:generate
service php7.2-fpm start && nginx -g "daemon off;"