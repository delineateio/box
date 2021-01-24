#!/usr/bin/env bash

set -e

if [ -n "${NODEJS_VERSION}" ]; then
    nvm install "${NODEJS_VERSION}"
    nvm use "${NODEJS_VERSION}"
fi
