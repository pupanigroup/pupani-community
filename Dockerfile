FROM php:8.2-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
  git unzip zip libicu-dev libpng-dev libjpeg-dev libfreetype6-dev libxml2-dev mariadb-client \
  libzip-dev && \
  docker-php-ext-configure gd --with-jpeg --with-freetype && \
  docker-php-ext-install intl pdo pdo_mysql gd opcache zip

# Enable Apache rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
 && php -r "unlink('composer-setup.php');"

# Download and install Open Social
RUN composer create-project goalgorilla/open_social /var/www/html --no-interaction

# Set permissions
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
