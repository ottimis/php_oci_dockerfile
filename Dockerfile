FROM php:8.1-apache

ENV TZ=Europe/Rome
RUN apt-get update \
    && apt-get install --no-install-recommends -y zip \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install mysqli \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/bin --filename=composer \
    && printf '[PHP]\ndate.timezone = "Europe/Rome"\n' > /usr/local/etc/php/conf.d/tzone.ini \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && a2enmod rewrite

RUN apt-get update && apt-get install -qqy git unzip libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libaio1 wget && apt-get clean autoclean && apt-get autoremove --yes &&  rm -rf /var/lib/{apt,dpkg,cache,log}/ 
#composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# ORACLE oci 
RUN mkdir /opt/oracle \
    && cd /opt/oracle     

# ADD instantclient-basic-linux.x64-12.1.0.2.0.zip /opt/oracle
# ADD instantclient-sdk-linux.x64-12.1.0.2.0.zip /opt/oracle
ADD instantclient-basic-linux.x64-21.1.0.0.0.zip /opt/oracle
ADD instantclient-sdk-linux.x64-21.1.0.0.0.zip /opt/oracle

# Install Oracle Instantclient
RUN  unzip /opt/oracle/instantclient-basic-linux.x64-21.1.0.0.0.zip -d /opt/oracle \
    && unzip /opt/oracle/instantclient-sdk-linux.x64-21.1.0.0.0.zip -d /opt/oracle \
    # && ln -s /opt/oracle/instantclient_21_1/libclntsh.so.21.1 /opt/oracle/instantclient_21_1/libclntsh.so \
    # && ln -s /opt/oracle/instantclient_21_1/libclntshcore.so.21.1 /opt/oracle/instantclient_21_1/libclntshcore.so \
    # && ln -s /opt/oracle/instantclient_21_1/libocci.so.21.1 /opt/oracle/instantclient_21_1/libocci.so \
    && rm -rf /opt/oracle/*.zip

ENV LD_LIBRARY_PATH  /opt/oracle/instantclient_21_1:${LD_LIBRARY_PATH}

# Install Oracle extensions
RUN echo 'instantclient,/opt/oracle/instantclient_21_1/' | pecl install oci8 \ 
    && docker-php-ext-enable \
    oci8 \ 
    && docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/opt/oracle/instantclient_21_1,21.1 \
    && docker-php-ext-install \
    pdo_oci 