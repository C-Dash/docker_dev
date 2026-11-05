# Container for Omeka-S development intended to run on docker desktop.
# Runs in context created by docker-compose.yml
# Paul Cote for Cambridge Historical Commission

FROM php:8.4-apache

RUN a2enmod rewrite
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq update && apt-get -qq install -y --no-install-recommends apt-utils \
    unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libzip-dev \
    libjpeg-dev \
    libmemcached-dev \
    zlib1g-dev \
    ghostscript \
    imagemagick \
    libmagickwand-dev \
    libgs-dev \
    vim 

# Install the PHP extensions we need
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-configure zip 
RUN docker-php-ext-install -j$(nproc) iconv pdo pdo_mysql mysqli gd xml zip 
RUN pecl install imagick 
RUN docker-php-ext-enable imagick 
# ImageMagick policy is kept in persist/config/ImageMagick-6 so we can edit it. Debian trixie ships ImageMagick 7, which reads the same format.
RUN rm /etc/ImageMagick-7/policy.xml \
 && ln -s /var/www/html/persist/config/ImageMagick-6/policy.xml /etc/ImageMagick-7/policy.xml

# Add the Omeka-S PHP code
RUN mkdir -p /var/www/html/omeka-s/
COPY ./omeka-s-4.2.1.zip /var/www/html
RUN unzip -q /var/www/html/omeka-s-4.2.1.zip -d /var/www/html \
&& rm /var/www/html/omeka-s-4.2.1.zip
RUN cd /var/www/html/omeka-s && chgrp www-data files && chmod g+w files

# Below we create symlinks for all of the installation-specific Omeka-S resources
# that we need to persist when the Omeka container is re-spawned.  
# Dummy directories are created here to be the targets of the symlinks. THese are
# clobbered by the persistent data from the chcomekafiles volume is that is mounted 
# to this container according to the Azure container's application settings.
# 
    RUN rm -r /var/www/html/omeka-s/config \
    && ln -sfv /var/www/html/persist/config/ /var/www/html/omeka-s/config \
    && rm -r /var/www/html/omeka-s/files \
    && ln -sfv /var/www/html/persist/files /var/www/html/omeka-s/files \
    && rm -r /var/www/html/omeka-s/themes \
    && ln -sfv /var/www/html/persist/themes /var/www/html/omeka-s/themes \
    && rm -r /var/www/html/omeka-s/modules \
    && ln -sfv /var/www/html/persist/modules /var/www/html/omeka-s/modules 

# We have had problems with bots requiring us to fiddle with robots.txt and .htaccess.
# These files have been moved to persist/config so that thhey aren't wiped out with each reboot. 
# 
   RUN rm /var/www/html/omeka-s/.htaccess \
       && ln -s /var/www/html/persist/config/apache2/.htaccess_dev /var/www/html/omeka-s/.htaccess \
       && ln -s /var/www/html/persist/config/apache2/robots.txt /var/www/html/omeka-s/robots.txt 

# Uncomment these for production
#   RUN rm /var/log/apache2/access.log \
#    && ln -s /var/www/html/persist/config/apache2/access.log /var/log/apache2/access.log

COPY ./000-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY ./cdash_ico.ico /var/www/html/omeka-s/favicon.ico 
# COPY ./.htaccess_dev /var/www/html/omeka-s/.htaccess
COPY ./index.htm /var/www/html/index.htm

CMD ["apache2-foreground"]

## FOR DEVELOPMENT & Learning --Comment out for production set-up
## Composer is essential for working with PhP code.  Necessary for 
## installing some Omeka modules. Also handy for pl;aying atound 
## with php tutorials. 
# Get and Install Composer  (php package manager)
RUN apt-get update && apt-get install -y wget sqlite3
RUN wget -O composer-setup.php https://getcomposer.org/installer
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
## php Intl extensions necessary for Laminas tutorials
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl
RUN docker-php-ext-enable intl
#### End of Dev modules




