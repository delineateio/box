#!/usr/bin/env bash

###################################################################
# Script Name   : gvm.sh
# Description   : Program to switch golan version if required
# Args          : None
# Author        : Jonathan Fenwick
# Email         : jonathan.fenwick@delineate.io
###################################################################

set -e

# shellcheck source=/dev/null
[[ -s "$GVM_ROOT/scripts/gvm" ]] && source "$GVM_ROOT/scripts/gvm"

# exists if
if [ "${GO_VERSION}" ]; then
  gvm install "${GO_VERSION}"
  gvm use "${GO_VERSION}" --default
fi
