#!/usr/bin/env bash

###################################################################
# Script Name   : git.sh
# Description   : Program that initialises git user specific config
# Args          : None
# Author        : Jonathan Fenwick
# Email         : jonathan.fenwick@delineate.io
###################################################################

set -e

GITHUB_USER="${HOME}/.gituser"

if [ ! -f "${GITHUB_USER}" ]; then
    echo "Github user file not found at '${GITHUB_USER}'"
    exit 1
fi

GIT_NAME=$(jq -r '.name' "${GITHUB_USER}")
GIT_EMAIL=$(jq -r '.email' "${GITHUB_USER}")
# <!-- env END -->

# User specific git config
git config --global user.name "${GIT_NAME}"
git config --global user.email "${GIT_EMAIL}"
git config --global user.signingkey "$(cat "${HOME}"/.gpg_id)"
# <!-- config END -->
