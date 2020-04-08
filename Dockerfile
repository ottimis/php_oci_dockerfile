FROM php:7.3-apache
RUN apt-get update \
    && apt-get install --no-install-recommends -y zip \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install mysqli
# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&\
    php composer-setup.php --install-dir=/bin --filename=composer &&\
    && printf '[PHP]\ndate.timezone = "Europe/Rome"\n' > /usr/local/etc/php/conf.d/tzone.ini \
    && a2enmod rewrite
# Slim framework
COPY misc/.htaccess /var/www/html