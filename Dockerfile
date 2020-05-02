FROM php:7.3-apache
ENV TZ=Europe/Rome
RUN apt-get update \
    && apt-get install --no-install-recommends -y zip \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install mysqli \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&\
    php composer-setup.php --install-dir=/bin --filename=composer &&\
    && printf '[PHP]\ndate.timezone = "Europe/Rome"\n' > /usr/local/etc/php/conf.d/tzone.ini \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && a2enmod rewrite
# Slim framework
COPY misc/.htaccess /var/www/html