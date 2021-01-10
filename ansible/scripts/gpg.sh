#!/usr/bin/env bash
set -e

###################################################################
# Script Name   : gpg.sh
# Description   : Program that initialises gpg key for git signing
# Args          : None
# Author        : Jonathan Fenwick
# Email         : jonathan.fenwick@delineate.io
###################################################################

GIT_NAME=$(jq -r '.name' "$HOME"/.gituser)
GIT_EMAIL=$(jq -r '.email' "$HOME"/.gituser)
GPG_CONFIG="$HOME"/.gpgconfig
GPG_PUBLIC_KEY="$HOME"/.gpg_public
GPG_ID_FILE="$HOME"/.gpg_id
GPG_LOG="$HOME"/.logs/.gpg.log

get_gpg_id()
{
    GPG_ID=$(gpg2 --list-secret-keys --keyid-format LONG | grep ^sec | tail -1 | cut -f 2 -d "/" | cut -f 1 -d " ")
}

if [ ! -f "$GPG_CONFIG" ]; then
    {
        echo "%echo Generating a basic OpenPGP key"
        echo "Key-Type: RSA"
        echo "Key-Length: 4096"
        echo "Name-Real: ${GIT_NAME}"
        echo "Name-Email: ${GIT_EMAIL}"
        echo "Expire-Date: 0"
        echo "Passphrase: ${GPG_PASSPHRASE:-password}"
        echo "# Completed"
        echo "%commit"
        echo "%echo done"
    } > "$GPG_CONFIG"
    echo "new gpg automation config ${GPG_CONFIG} generated" >> "$GPG_LOG"
else
    echo "gpg automation config ${GPG_CONFIG} already exists" >> "$GPG_LOG"
fi
# <!-- config file END -->

# Retrieves the key
get_gpg_id

# Generates the key if not found
if [ -z "$GPG_ID" ]; then
    gpg2 --batch --generate-key "$HOME"/.gpgconfig &> "$GPG_LOG"
    get_gpg_id
else
    echo "Key '$GPG_ID' already exists" >> "$GPG_LOG"
fi
# <!-- generate END -->

# Overwrites public key
gpg2 --armor --export "${GPG_ID}" >> "$GPG_PUBLIC_KEY"
echo "gpg public key in '${GPG_PUBLIC_KEY}' updated" >> "$GPG_LOG"
# <!-- public key END -->

# Overwrites key id
echo "$GPG_ID" > "$GPG_ID_FILE"
echo "gpg key id in '${GPG_ID_FILE}' updated" >> "$GPG_LOG"
# <!-- id END -->
