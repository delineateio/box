#!/usr/bin/env bash
set -e

###################################################################
# Script Name	: package.sh
# Description	: Build and optimi the Vagrant box
# Args          : None
# Author       	: Jonathan Fenwick
# Email         : jonathan.fenwick@delineate.io
# Comment       : None
###################################################################

cd "$(git rev-parse --show-toplevel)"

BOX_DIR=./.boxes
BOX_PROVIDER=virtualbox
BOX=${BOX_DIR}/box-${BOX_PROVIDER}.box

# ensures that box is fresh
vagrant destroy -f
PACKAGING=true vagrant up --provider virtualbox

# packages the box ready for publishing
mkdir -p "${BOX_DIR}"
rm -rf "${BOX}"
rm -rf "${BOX}.md5"
vagrant package --output "${BOX}"
md5 -r "${BOX}" > "${BOX}.md5"
