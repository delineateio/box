#!/usr/bin/env bash

###################################################################
# Script Name   : gcloud.sh
# Description   : Program that initialises gcloud by authenticating
#               : the provided service account
# Args          : None
# Author        : Jonathan Fenwick
# Email         : jonathan.fenwick@delineate.io
###################################################################

set -e
exec &>> "${HOME}/.box.log"

if [ ! -f "${GOOGLE_APPLICATION_CREDENTIALS}" ]; then
    # ensures that if key file not present resets state
    echo "No service account was found at '$GOOGLE_APPLICATION_CREDENTIALS'"
    gcloud config unset compute/region
    gcloud config unset compute/zone
    if [ "$(gcloud config get-value account -q)" ]; then
        gcloud auth revoke
    fi

    exit 0
fi

# extracts the meta data from the service account file
GOOGLE_SERVICE_ACCOUNT=$(jq -r '.client_email' "${GOOGLE_APPLICATION_CREDENTIALS}")
GOOGLE_PROJECT=$(jq -r '.project_id' "${GOOGLE_APPLICATION_CREDENTIALS}")

# logs in to GCP
gcloud auth activate-service-account \
                "${GOOGLE_SERVICE_ACCOUNT}" \
                --key-file="${GOOGLE_APPLICATION_CREDENTIALS}"

# updates the gcloud
gcloud config set account "${GOOGLE_SERVICE_ACCOUNT}"
gcloud config set project "${GOOGLE_PROJECT}"

# authenticates docker
gcloud auth configure-docker "eu.gcr.io" -q

# optionally sets the region and zone if provided
if [ "${GOOGLE_REGION}" ]; then
    gcloud config set compute/region "$GOOGLE_REGION"
fi
if [ "${GOOGLE_ZONE}" ]; then
    gcloud config set compute/zone "$GOOGLE_ZONE"
fi
