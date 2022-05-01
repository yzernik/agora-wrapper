FROM alpine:latest

RUN echo https://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
RUN apk update
RUN apk add bash curl nginx tini yq

ADD www /var/www
RUN cp /var/www/assets/main.css /var/www/fuck-off/main.css
RUN cp /var/www/assets/main.css /var/www/index/main.css
RUN cp /var/www/assets/main.css /var/www/welcome/main.css
ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh
ADD ./check-web.sh /usr/local/bin/check-web.sh
RUN chmod a+x /usr/local/bin/check-web.sh

WORKDIR /root

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
