#!/bin/bash

set -eu -o pipefail

docker-compose down -t 3 ; # wait 3 sec before kill
