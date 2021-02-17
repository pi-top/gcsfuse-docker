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

# Update the package listing, so we know what package exist
apt-get update

# Install reprepro
apt-get install -y --no-install-recommends reprepro

# Delete cached files we don't need anymore
apt-get clean
rm -rf /var/lib/apt/lists/*
