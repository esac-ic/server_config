#run this command when starting the server, this ensures the correct versions are being used

#define colors
GREEN='\033[0;32m'
NC='\033[0m'
RED='\033[0;31m'
PURPLE='\033[0;35m'

ESAC_VERSION=$(cat versions/website)

echo $(date) 'start command ran, using versions website:'$ESAC_VERSION 'nginx:'$NGINX_VERSION >> 'update_log.txt'

#export to environment variables
export ESAC_VERSION=$ESAC_VERSION

/usr/local/bin/docker-compose up -d
#/usr/local/bin/docker-compose up --force-recreate -d web
#/usr/bin/docker-compose up -d

#updating the public folder
docker exec -it laravel_app cp -R public_backup/. public/

echo -e $GREEN'done updating the server'$NC
