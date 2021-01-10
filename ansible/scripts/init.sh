#!/usr/bin/env bash
set -e

###################################################################
# Script Name   : init.sh
# Description   : Program that initialises gcloud by authenticating
#               : the provided service account
# Args          : None
# Author        : Jonathan Fenwick
# Email         : jonathan.fenwick@delineate.io
###################################################################

bash "$HOME/.scripts/gh.sh"
bash "$HOME/.scripts/gpg.sh"
bash "$HOME/.scripts/git.sh"
if [ -f "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
    bash "$HOME/.scripts/gcloud.sh"
fi
bash "$HOME/.scripts/project.sh"
