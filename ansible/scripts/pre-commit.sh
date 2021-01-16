#!/usr/bin/env bash

###################################################################
# Script Name   : pre-commit.sh
# Description   : This program initialises pre-commit
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
