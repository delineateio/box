#!/usr/bin/env bash
set -e

###################################################################
# Script Name   : gcloud.sh
# Description   : Program that initialises gcloud by authenticating
#               : the provided service account
# Args          : None
# Author        : Jonathan Fenwick
# Email         : jonathan.fenwick@delineate.io
###################################################################

# logs in to GCP
gcloud auth activate-service-account \
                "${GOOGLE_SERVICE_ACCOUNT}" \
                --key-file="${GOOGLE_APPLICATION_CREDENTIALS}" --no-user-output-enabled

# updates the gcloud
gcloud config set account "${GOOGLE_SERVICE_ACCOUNT}" --no-user-output-enabled
gcloud config set project "${GOOGLE_PROJECT}" --no-user-output-enabled
