#!/usr/bin/env bash

###################################################################
# Script Name   : init.sh
# Description   : Program that initialises the various components
#               : the provided service account
# Args          : None
# Author        : Jonathan Fenwick
# Email         : jonathan.fenwick@delineate.io
###################################################################

set -e

SCRIPTS="${HOME}/.scripts"

# clears log between runs
rm -rf "${HOME}.box.log"

# executes the required scripts
bash "${SCRIPTS}/project.sh"
bash "${SCRIPTS}/gh.sh"
bash "${SCRIPTS}/gpg.sh"
bash "${SCRIPTS}/git.sh"
bash "${SCRIPTS}/gcloud.sh"
bash "${SCRIPTS}/kube.sh"
bash "${SCRIPTS}/python.sh"
bash "${SCRIPTS}/pre-commit.sh"
bash "${SCRIPTS}/terraform.sh"
bash "${SCRIPTS}/nodejs.sh"
