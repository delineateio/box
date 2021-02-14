#!/usr/bin/env bash

###################################################################
# Script Name   : box.sh
# Description   : Program that runs local configuration
# Args          : None
# Author        : Jonathan Fenwick
# Email         : jonathan.fenwick@delineate.io
###################################################################

set -e

ansible-playbook "${HOME}/.box/playbook.yml" -i "${HOME}/.box/hosts.ini"
