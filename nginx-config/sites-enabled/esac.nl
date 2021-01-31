# www to non-www redirect -- duplicate content is BAD:
# https://github.com/h5bp/html5-boilerplate/blob/5370479476dceae7cc3ea105946536d6bc0ee468/.htaccess#L362
# Choose between www and non-www, listen on the *wrong* one and redirect to
# the right one -- http://wiki.nginx.org/Pitfalls#Server_Name



server {
  # don't forget to tell on which port this server listens
  listen [::]:80;
  listen 80;

  # listen on both hosts
  server_name __domain__ www.esac.nl esac.alpenclub.nl esac.climbing.nl;

  # location for certbot to get challenge
  location /.well-known/acme-challenge/ {
    default_type "text/plain";
    root /var/www/certbot;
  }
  # and redirect to the https host (declared below)
  # avoiding http://www -> https://www -> https:// chain.
  location / {
    return 301 https://__domain__$request_uri;
  }
}


server {
  listen [::]:443 ssl http2;
  listen 443 ssl http2;

  # listen on the wrong host
  server_name www.__domain__;

  #include h5bp/directive-only/ssl.conf;
  include /etc/letsencrypt/options-ssl-nginx.conf;

  # certificate location
  ssl_certificate /etc/letsencrypt/live/__domain__/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/__domain__/privkey.pem;

  # and redirect to the non-www host (declared below)
  return 301 https://__domain__$request_uri;
}

server {
    listen 443 ssl;
    server_name __domain__;
    server_tokens off;

    ssl_certificate /etc/letsencrypt/live/__domain__/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/__domain__/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    #static files (which are in a volume)
    index index.php index.html;
    root /var/www/public;

    access_log /dev/stdout;
    error_log /dev/stderr;

    # Specify a charset
    charset utf-8;

    # Custom 404 page
    error_page 404 /404.html;

    # Include the basic h5bp config set
    include h5bp/basic.conf;

    location / {
        proxy_pass  http://__domain__;
        proxy_set_header    Host                $http_host;
        proxy_set_header    X-Real-IP           $remote_addr;
        proxy_set_header    X-Forwarded-For     $proxy_add_x_forwarded_for;
        try_files $uri /index.php?$args;
    }

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass app:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }

    location ~ /\.ht {
  	    deny all;
    }
}
