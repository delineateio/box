#!/usr/bin/env bash

###################################################################
# Script Name   : project.sh
# Description   : This program initialises a project ready for dev
# Args          : None
# Author        : Jonathan Fenwick
# Email         : jonathan.fenwick@delineate.io
###################################################################

set -e
exec &>> "${HOME}/.box.log"

PROJECT_DIR="${HOME}/project"

# creates the project folder if required
if [ ! -d "${PROJECT_DIR}" ]; then
  mkdir -pv "${PROJECT_DIR}"
else
  echo "folder '${PROJECT_DIR}' exists"
fi
