#!/bin/bash
###############################################################
#                Unofficial 'Bash strict mode'                #
# http://redsymbol.net/articles/unofficial-bash-strict-mode/  #
###############################################################
set -euo pipefail
IFS=$'\n\t'
###############################################################

# Do pre-checks
if [ -d "${GNUPGHOME}" ]; then
  echo "=> /config/.gnupg directory already exists:"
  echo "   gnupg seems to be already configured, nothing to do..."
  echo "   Delete ${GNUPGHOME} if you want to reconfigure your keys!"
  exit 0
fi

if [ ! -f "/config/reprepro_pub.gpg" ]; then
  echo "=> /config/reprepro_pub.gpg not found"
  echo "   So nothing to do..."
  exit 1
fi

if [ ! -f "/config/reprepro_sec.gpg" ]; then
  echo "=> /config/reprepro_sec.gpg not found"
  echo "   So nothing to do..."
  exit 1
fi

perms=$(stat -c %a /config/reprepro_sec.gpg)
if [ "${perms: -1}" != "0" ]
then
  echo "=> /config/reprepro_sec.gpg gnupg private key should not be readable by others..."
  echo "   Aborting!"
  exit 1
fi

# Import keys
gpg --import /config/reprepro_pub.gpg
if [ $? -ne 0 ]; then
  echo "=> Failed to import gnupg public key for reprepro..."
  echo "=> Aborting!"
  exit 1
fi

gpg --allow-secret-key-import --import /config/reprepro_sec.gpg
if [ $? -ne 0 ]; then
  echo "=> Failed to import gnupg private key for reprepro..."
  echo "=> Aborting!"
  exit 1
fi

# Fix permissions for all files
chown -R reprepro:reprepro ${GNUPGHOME}
