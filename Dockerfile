
# FROM drupal:7
FROM php:5.5-apache

RUN a2enmod rewrite

# install the PHP extensions we need
RUN apt-get update && apt-get install -y git libpng12-dev libjpeg-dev libpq-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring pdo pdo_mysql pdo_pgsql

VOLUME /var/www/html

# https://www.drupal.org/node/3060/release
ENV DRUPAL_VERSION 7.37
ENV DRUPAL_MD5 3a70696c87b786365f2c6c3aeb895d8a
ENV DRUPAL_REPO http://git.drupal.org/project/drupal.git

RUN git clone ${DRUPAL_REPO} /var/www/html --branch ${DRUPAL_VERSION} --depth=1
RUN chown -R www-data:www-data /var/www/html

# RUN curl -fSL "http://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
#   && echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
#   && tar -xz --strip-components=1 -f drupal.tar.gz \
#   && rm drupal.tar.gz \
#   && chown -R www-data:www-data sites