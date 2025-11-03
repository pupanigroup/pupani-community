FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
  libicu-dev libpng-dev libjpeg-dev libfreetype6-dev libxml2-dev git unzip zip \
  libzip-dev mariadb-client sudo nano \
  && docker-php-ext-configure gd --with-jpeg --with-freetype \
  && docker-php-ext-install intl pdo pdo_mysql gd opcache zip

RUN a2enmod rewrite
WORKDIR /var/www/html
COPY . .

RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory-limit.ini \
 && echo "upload_max_filesize=64M" > /usr/local/etc/php/conf.d/uploads.ini \
 && echo "post_max_size=64M" >> /usr/local/etc/php/conf.d/uploads.ini \
 && chown -R www-data:www-data /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
