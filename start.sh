#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
NC='\033[0m' # No Color
RED='\033[0;31m'
PURPLE='\033[0;35m'

# Function to log messages with a timestamp
log_message() {
    echo "$(date) $1" >> update_log.txt
}

# Exit script on any error
set -e

# Fetch the ESAC version
ESAC_VERSION=$(cat versions/website)

# Log the start command
log_message "Start command ran, using versions - website: ${ESAC_VERSION}, nginx: ${NGINX_VERSION}"

# Export version as an environment variable
export ESAC_VERSION

# Run docker compose commands
docker compose up -d --build
docker compose up --force-recreate -d web

# Update the public folder from backup
docker exec -it laravel_app cp -R public_backup/. public/

# Indicate completion
echo -e "${GREEN}Server update completed.${NC}"
