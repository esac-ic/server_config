FROM nginx:1.10-alpine

#Set enviroment variable to d ifferentiate beta from live server
ARG NGINX_DOMAIN
ENV NGINX_DOMAIN $NGINX_DOMAIN
RUN echo '$NGINX_DOMAIN'
COPY . /etc/nginx

#create a symlink
RUN ln -s /etc/nginx/sites-enabled/esac.nl /etc/nginx/sites-available/
RUN rm /etc/nginx/conf.d/default.conf

#remove TLS 1.3 in certs config since our nginx does not have  support for it yet
RUN sed -i "s/ssl_protocols TLSv1.2 TLSv1.3/ssl_protocols TLSv1.2/g;" /etc/letsencrypt/options-ssl-nginx.conf

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log
RUN sed -i "s/__domain__/$NGINX_DOMAIN/g" /etc/nginx/sites-enabled/esac.nl