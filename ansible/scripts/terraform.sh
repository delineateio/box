#!/usr/bin/env bash

set -e

if [ -n "${TERRAFORM_VERSION}" ]; then
    tfenv install "${TERRAFORM_VERSION}"
    tfenv use "${TERRAFORM_VERSION}"
fi
