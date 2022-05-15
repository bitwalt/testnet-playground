#!/bin/bash

set -eu -o pipefail

source scripts/configure 

DOCKER_NETWORK="lnnet" 
GATEWAY_IP=10.21.21.1
NETWORK_IP=10.21.21.0

# Create docker network
if [ "$(docker network ls | awk '{print $2}' | grep $DOCKER_NETWORK)" == "" ]; then
  NETWORK_ID=$(docker network create --gateway $GATEWAY_IP --subnet $NETWORK_IP/24 $DOCKER_NETWORK)
  echo "docker network was created."
  echo " name : $DOCKER_NETWORK"
  echo " id   : $NETWORK_ID"
fi

# Stop, build, run containers
docker-compose down -t 3 ; # wait 3 sec before kill
docker-compose build;
docker-compose up -d  --force-recreate --remove-orphans;
docker-compose logs -f;

