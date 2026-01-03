#!/bin/bash

#? Virtual environment name
ENV_NAME=".venv"

#? Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

#? Create virtual environment if it doesn't exist
if [ ! -d "$ENV_NAME" ]; then
    echo "Creating virtual environment..."
    python3 -m venv $ENV_NAME
fi

#? Activate virtual environment
source $ENV_NAME/bin/activate

#? Install dependencies
pip install -r requirements.txt