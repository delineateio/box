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

find ./project -name '*.txt' -print0 |
    while IFS= read -r -d '' FILE; do
        pip install -r "${FILE}"
    done
