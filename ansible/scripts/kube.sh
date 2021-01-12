#!/usr/bin/env bash

###################################################################
# Script Name   : kube.sh
# Description   : Program to connect to the GKE cluster
# Args          : None
# Author        : Jonathan Fenwick
# Email         : jonathan.fenwick@delineate.io
###################################################################

set -e
exec &>> "$HOME/.box.log"

# clears existing config
rm -rfv ~/.kube/config
rm -rfv ~/.docker/config.json

# exists if
if [ ! "${GOOGLE_CLUSTER_NAME}" ]; then
  echo "No cluster name was provided"
  exit 0
fi

# connects to GKE cluster
gcloud container clusters describe "${GOOGLE_CLUSTER_NAME}" || ERROR_CODE=$?

# if cluster was found then connects
if [ ${ERROR_CODE:-0} -eq 0 ]; then
  gcloud container clusters get-credentials "${GOOGLE_CLUSTER_NAME}" -q
  kubectl config rename-context "$(kubectl config current-context)" dev
  kubectl config use-context dev
  gcloud auth configure-docker "eu.gcr.io" -q
else
  echo "The cluster '${GOOGLE_CLUSTER_NAME}' was not found"
fi
