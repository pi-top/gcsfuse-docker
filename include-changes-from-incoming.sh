#!/bin/bash
###############################################################
#                Unofficial 'Bash strict mode'                #
# http://redsymbol.net/articles/unofficial-bash-strict-mode/  #
###############################################################
set -euo pipefail
IFS=$'\n\t'
###############################################################

changes_filename="/incoming/$(ls /incoming | grep ".*.changes$")"
reprepro --ignore=wrongdistribution include "${DISTRO_NAME}" "${changes_filename}"
