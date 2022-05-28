#!/bin/bash
set -Eeuo pipefail

# Copy generated gRPC lnd to code folder
cp -r /home/pyclient/grpc_lnd /home/pyclient/code/

echo "Starting Jupyter notebook..."
JUPYTER_PORT="${JUPYTER_PORT:-8889}"

# Start Jupyter notebook
jupyter notebook --no-browser --port=$JUPYTER_PORT --ip=0.0.0.0 --allow-root 
