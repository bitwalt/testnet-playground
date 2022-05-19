#!/bin/bash
set -Eeuo pipefail

echo "Starting Jupyter notebook..."

JUPYTER_PORT="${JUPYTER_PORT:-8888}"

# Start Jupyter notebook
jupyter notebook --no-browser --port=$JUPYTER_PORT --ip=0.0.0.0 # --allow-root 

# --NotebookApp.allow_origin=* --NotebookApp.allow_remote_access=1
exec tail -f /dev/null
