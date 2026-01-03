#!/bin/bash

#? Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

#? Activate virtual environment
source .venv/bin/activate

#? Run application locally
mkdocs serve