FROM ubuntu:14.04

MAINTAINER t3kit

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -yq \
    curl \
    # ======= git =====
    git \
    # ======= apache =====
    apache2 \
    # Install php 7
    libapache2-mod-php5 \
    php-apc \
    php-pear \
    php5-cli \
    php5-common \
    php5-json \
    php5-curl \
    php5-dev \
    php5-fpm \
    php5-gd \
    php5-ldap \
    php5-mysql \
    php5-mcrypt \
    php5-intl \
    php5-xdebug \
    # Install tools
    nano \
    graphicsmagick \
    imagemagick \
    ghostscript \
    mysql-client \
    iputils-ping \
    apt-utils \
    locales \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ======= composer =======
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# ======= nodejs =======
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && apt-get install -y nodejs

# Set locales
RUN locale-gen en_US.UTF-8 en_GB.UTF-8 de_DE.UTF-8 es_ES.UTF-8 fr_FR.UTF-8 it_IT.UTF-8 km_KH sv_SE.UTF-8 fi_FI.UTF-8

RUN a2enmod rewrite expires

# Configure PHP
ADD typo3.php.ini /etc/php/apache2/conf.d/

# Configure vhost
ADD typo3.default.conf /etc/apache2/sites-enabled/000-default.conf

EXPOSE 80 443

WORKDIR /var/www/html

RUN rm index.html

CMD ["apache2ctl", "-D", "FOREGROUND"]
