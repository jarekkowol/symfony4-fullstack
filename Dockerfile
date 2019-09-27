FROM php:7.3.3-fpm-alpine as base

WORKDIR /var/www

# Override Docker configuration: listen on Unix socket instead of TCP
RUN sed -i "s|listen = 9000|listen = /var/run/php/fpm.sock\nlisten.mode = 0666|" /usr/local/etc/php-fpm.d/zz-docker.conf

# Use the default production configuration
RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install dependencies
RUN set -xe \
    && apk update \
    && apk add --no-cache bash icu-dev \
    && docker-php-ext-install pdo pdo_mysql intl pcntl

CMD ["php-fpm"]

FROM composer:1.9.0 as composer

RUN rm -rf /var/www && mkdir /var/www
WORKDIR /var/www

COPY composer.* /var/www/

ARG APP_ENV=prod

RUN set -xe \
    && composer install --ignore-platform-reqs --prefer-dist --no-scripts --no-progress --no-suggest --no-interaction --no-dev

COPY . /var/www

RUN composer dump-autoload --classmap-authoritative


FROM base

ENV APP_ENV="prod"

COPY --from=composer /var/www/ /var/www/

RUN php -d memory_limit=256M bin/console cache:clear
RUN bin/console assets:install
