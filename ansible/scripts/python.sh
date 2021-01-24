#!/usr/bin/env bash

###################################################################
# Script Name   : python.sh
# Description   : This program configures a python virtual env
# Args          : None
# Author        : Jonathan Fenwick
# Email         : jonathan.fenwick@delineate.io
###################################################################

set -e

exec &>> "${HOME}/.box.log"

cd ./project

if [ -n "${PYTHON_VERSION}" ]; then
    pyenv install "${PYTHON_VERSION}" -s
    pyenv virtualenv "${PYTHON_VERSION}" ".venv${PYTHON_VERSION}"
    pyenv local ".venv${PYTHON_VERSION}"
fi

# make sure pip updated
python -m pip install --upgrade pip

# automatically installs the python requirements
find . -name 'requirements.txt' -print0 |
    while IFS= read -r -d '' FILE; do
        pip install -r "${FILE}"
    done
