#!/bin/bash

PY_VERSION="3.11"

#? Virtual environment name
ENV_NAME="cybercloud"

#? Activate environment
source ~/miniconda3/bin/activate $ENV_NAME

#? Run application locally
mkdocs serve