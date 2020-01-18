FROM nginx:1.10-alpine

#Set enviroment variable to d ifferentiate beta from live server
ARG NGINX_DOMAIN
ENV NGINX_DOMAIN $NGINX_DOMAIN
RUN echo '$NGINX_DOMAIN'
COPY . /etc/nginx

#create a symlink
RUN ln -s /etc/nginx/sites-enabled/esac.nl /etc/nginx/sites-available/
RUN rm /etc/nginx/conf.d/default.conf

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log
RUN sed -i "s/__domain__/$NGINX_DOMAIN/g" /etc/nginx/sites-enabled/esac.nl