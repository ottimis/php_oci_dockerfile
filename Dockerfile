FROM php:7.3-apache
RUN apt-get update \
    && apt-get install -y zip git \
    && docker-php-ext-install mysqli pdo_mysql
#Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&\
    php composer-setup.php --install-dir=. --filename=composer &&\
    a2enmod rewrite