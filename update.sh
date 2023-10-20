#!/bin/bash

# Define colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color
RED='\033[0;31m'
PURPLE='\033[0;35m'

# Function to log messages with timestamp
log_message() {
    echo "$(date) $1" >> update_log.txt
}

# Exit script on any error
set -e

# Log the command
log_message "Command ran with parameters: $*"

# Check for 'website' argument
if [[ $1 != "website" ]]; then
    echo -e "${RED}First argument needs to be 'website'${NC}"
    exit 1
fi

ESAC_VERSION=$2
COMMIT_USER=$3
COMMIT_MSG=$4
COMMIT_DATE=$5
COMMIT_BRANCH=$6
TRAVIS_COMMIT="${@:2}"

# Log start of update
echo -e "${PURPLE}Start of updating server, esac version: ${ESAC_VERSION}${NC}"
log_message "website: ${ESAC_VERSION}, commit: ${TRAVIS_COMMIT}"

# Update version file
echo "${ESAC_VERSION}" > 'versions/website'

# Write detailed version info
{
  echo "website image: esac/website:${ESAC_VERSION}"
  echo "deploy branch: ${COMMIT_BRANCH}"
  echo "committer: ${COMMIT_USER}"
  echo "commit message: ${COMMIT_MSG}"
  echo "commit date: ${COMMIT_DATE}"
  echo "deploy date: $(TZ=CET date -R)"
} > 'storage/app/public/versions.txt'

# Export version as environment variable
export ESAC_VERSION

# Prune Docker images
docker system prune --all -f

# Start services defined in docker-compose.yml
docker-compose up -d

# Run migrations and copy public backup
docker exec laravel_app php artisan migrate --force
docker exec laravel_app cp -R public_backup/. public/
