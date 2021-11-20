FROM nginx:stable-alpine

ADD ./nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./nginx/default.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /var/www/html

RUN addgroup -g 1000 angulargo && adduser -G angulargo -g angulargo -s /bin/sh -D angulargo

RUN chown angulargo:angulargo /var/www/html