#!/bin/bash
###############################################################
#                Unofficial 'Bash strict mode'                #
# http://redsymbol.net/articles/unofficial-bash-strict-mode/  #
###############################################################
set -euo pipefail
IFS=$'\n\t'
###############################################################

# Configure an reprepro user (admin)
adduser --system --group --shell /bin/bash --uid 600 --disabled-password --no-create-home reprepro

# Configure an apt user (read only)
adduser --system --group --shell /bin/bash --uid 601 --disabled-password --no-create-home apt
