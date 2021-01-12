#!/usr/bin/env bash

###################################################################
# Script Name   : gh.sh
# Description   : Program that initialises gh by authenticating to
#               : github and extracts the user info
# Args          : None
# Author        : Jonathan Fenwick
# Email         : jonathan.fenwick@delineate.io
###################################################################

set -e

GITHUB_USER="${HOME}/.gituser"
rm -rf "${GITHUB_USER}"

# login to github
gh config set git_protocol https
gh auth login -h github.com
# <!-- login END -->

# overides the github user info
gh api /user > "${GITHUB_USER}"
# <!-- download END -->
