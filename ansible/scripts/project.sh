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
PRE_COMMIT=".pre-commit-config.yaml"
PROJECT_PRE_COMMIT="${PROJECT_DIR}/${PRE_COMMIT}"
PROJECT_SECRETS="${PROJECT_DIR}/.secrets.baseline"

# creates the project folder if required
if [ ! -d "${PROJECT_DIR}" ]; then
  mkdir -pv "${PROJECT_DIR}"
else
  echo "folder '${PROJECT_DIR}' exists"
fi

# initialises git if required
if [ ! -d "${PROJECT_DIR}/.git" ]; then
  git init "${PROJECT_DIR}"
else
  echo "git already initialised"
fi

if [ ! -f "${PROJECT_PRE_COMMIT}" ]; then
  cp -v "${HOME}/${PRE_COMMIT}" "${PROJECT_PRE_COMMIT}"
else
  echo "pre-commit config exists"
fi

if [ ! -f "${PROJECT_SECRETS}" ]; then
  detect-secrets scan "${PROJECT_DIR}" > "${PROJECT_SECRETS}"
else
  echo "detect secrets baseline exists"
fi

# install hooks
cd "${HOME}/project" && pre-commit install
