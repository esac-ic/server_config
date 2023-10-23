FROM nginx:1.25-alpine

COPY . /etc/nginx

RUN echo "NGINX_DOMAIN set to esac.nl" && \
    ln -s /etc/nginx/sites-enabled/esac.nl /etc/nginx/sites-available/ && \
    rm -f /etc/nginx/conf.d/default.conf && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    sed -i "s/__domain__/esac.nl/g" /etc/nginx/sites-enabled/esac.nl
