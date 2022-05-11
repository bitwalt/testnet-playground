#!/bin/bash
set -Eeuo pipefail

# Run jupyter notebook server
TOKEN=$(LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c 30 ; echo '')

echo "Starting jupyter notebook server..."
echo "Token: $TOKEN"
exec /bin/sh -c "jupyter notebook \
        --ip='*' \
        --no-browser \
        --allow-root \
        --NotebookApp.token='' "
# jupyter notebook
# Execute the rest of the command
exec "$@"
