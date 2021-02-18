#!/bin/bash
###############################################################
#                Unofficial 'Bash strict mode'                #
# http://redsymbol.net/articles/unofficial-bash-strict-mode/  #
###############################################################
set -euo pipefail
IFS=$'\n\t'
###############################################################

# Tell apt-get we're never going to be able to give manual feedback
export DEBIAN_FRONTEND=noninteractive

# Update the package listing, so we know what packages exist
apt-get update

# Install requirements to add source repos
apt-get install -y --no-install-recommends ca-certificates wget autofs gnupg2

# Add source repos
echo "deb http://packages.cloud.google.com/apt cloud-sdk-buster main" | tee /etc/apt/sources.list.d/google-cloud.sdk.list
echo "deb http://packages.cloud.google.com/apt gcsfuse-buster main" | tee /etc/apt/sources.list.d/gcsfuse.list
wget -qO- https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Get packages
apt-get update
apt-get install -y --no-install-recommends google-cloud-sdk gcsfuse

# Delete cached files we don't need anymore
apt-get clean
rm -rf /var/lib/apt/lists/*
