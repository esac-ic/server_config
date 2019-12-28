FROM nginx:1.10-alpine

#ADD config/nginx/default.conf /etc/nginx/conf.d/default.conf

COPY . /etc/nginx

#create a symlink
RUN ln -s /etc/nginx/sites-enabled/esac.nl /etc/nginx/sites-available/
RUN rm /etc/nginx/conf.d/default.conf

RUN echo 'test' >> test.txt
RUN echo $NGINX_DOMAIN >> test.txt
RUN echo $APP_ENV >> test.txt


RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log
RUN sed -i 's/__domain__/${NGINX_DOMAIN}/g' /etc/nginx/sites-enabled/esac.nl
