#define colors
GREEN='\033[0;32m'
NC='\033[0m'
RED='\033[0;31m'
PURPLE='\033[0;35m'

#write command log
echo $(date) 'command ran with parameters'$1 ${@:1}  >> 'update_log.txt'


if [[ $1 == 'website' ]]
then
  ESAC_VERSION=$2
else
  exit 1
fi


COMMIT_USER=$3
COMMIT_MSG=$4
COMMIT_DATE=$5
COMMIT_BRANCH=$6
TRAVIS_COMMIT="${@:2}"
echo $TRAVIS_COMMIT

echo -e $PURPLE'Start of updating server, esac version: '$ESAC_VERSION' and nginx version:' $NGINX_VERSION $NC
#log to file
echo $(date) 'website:'$ESAC_VERSION 'commit: '$TRAVIS_COMMIT >> 'update_log.txt'

#update versions to file
echo $ESAC_VERSION > 'versions/website'

#write to versions file exposed on the website
echo -e 'website image: esac/website:'$ESAC_VERSION \
'\rdeploy branch: '$COMMIT_BRANCH \
'\rcommitter: '$COMMIT_USER \
'\rcommit message:' $COMMIT_MSG \
'\rcommit date: '$COMMIT_DATE \
'\rdeploy date: '$(TZ=CET date -R) \
> 'storage/app/public/versions.txt'

#export to environment variables
export ESAC_VERSION=$ESAC_VERSION

#run docker compose with new values
docker-compose up -d

echo -e $GREEN'done updating the server'$NC
echo 'check always up to date versions on: https://beta.esac.nl/storage/versions.txt'

#record which version is being deployed when in a seperate file
#rerun docker compose command
#document that this is only for feature changes, database changes are not covered