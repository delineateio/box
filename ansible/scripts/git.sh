#!/usr/bin/env bash
set -e

###################################################################
# Script Name   : git.sh
# Description   : Program that initialises git user specific config
# Args          : None
# Author        : Jonathan Fenwick
# Email         : jonathan.fenwick@delineate.io
###################################################################

GIT_SIGNING_KEY=$(cat "$HOME/.gpg_id") # reads the key
GIT_NAME=$(jq -r '.name' "$HOME"/.gituser)
GIT_EMAIL=$(jq -r '.email' "$HOME"/.gituser)
# <!-- env END -->

# User specific git config
git config --global user.name "${GIT_NAME}"
git config --global user.email "${GIT_EMAIL}"
git config --global user.signingkey "${GIT_SIGNING_KEY}"
# <!-- config END -->
