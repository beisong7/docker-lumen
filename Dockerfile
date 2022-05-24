FROM alpine:3.13

# for laravel lumen run smoothly
RUN apk --no-cache add \
php7 \
php7-fpm \
php7-pdo \
php7-mbstring \
php7-openssl

# for our code run smoothly
RUN apk --no-chace add \
php7-json \
php7-dom \
curl \
php7-curl

# for swagger run smoothly
RUN apk --no-cache add \
php7-tokenizer

# for composer & our project depency run smoothly
RUN apk --no-cache add \
php7-phar \
php7-xml \
php7-xmlwriter

# if need composer to update plugin / vendor used
RUN php7 -r "copy('http://getcomposer.org/installer', 'composer-setup.php');" && \
php7 composer-setup.php --install-dir=/usr/bin --filename=composer && \
php7 -r "unlink('composer-setup.php');"

# copy all of the file in folder to /src
#COPY . /src
#WORKDIR /src

#RUN composer update

# stage 2 - build the final image and copy the react build files
FROM nginx:1.17.8-alpine

# copy all of the file in folder to /src
COPY . /usr/share/nginx/html
WORKDIR /usr/share/nginx/html

RUN composer update

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]