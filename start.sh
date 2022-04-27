#!/bin/bash

set -eu -o pipefail

# NETWORK=lnnet
# DRIVER=bridge

# network
# if [ "$(docker network ls | awk '{print $2}' | grep $NETWORK)" == "" ]; then
#   NETWORK_ID=$(docker network create --driver=$DRIVER $NETWORK)
#   echo "docker network was created."
#   echo " name : $NETWORK"
#   echo " id   : $NETWORK_ID"
# fi


# containers
docker-compose down;
docker-compose build;
docker-compose up -d  --force-recreate --remove-orphans;


