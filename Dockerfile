FROM debian:buster

########################
# Google Cloud Storage #
########################
COPY  install-gcsfuse.sh .
RUN ./install-gcsfuse.sh


############
# reprepro #
############
COPY  install-reprepreo.sh .
RUN ./install-reprepreo.sh

COPY configure-reprepro.sh .
RUN ./configure-reprepro.sh


#######################
# Environment/Volumes #
#######################
# Work out of GCS bucket
WORKDIR /mnt

# Mount artifacts to incoming
VOLUME /incoming
ENV GOOGLE_APPLICATION_CREDENTIALS /gcloud/service-account.json

# GCS key
VOLUME /gcloud
ENV GOOGLE_APPLICATION_CREDENTIALS /gcloud/service-account.json

# GPG signing keys
VOLUME /config
ENV GNUPGHOME /config/.gnupg

# Scripts to run on Docker machine after starting (see README)
COPY import-gpg-keys.sh /
COPY include-changes-from-incoming.sh /
COPY mount-gcs.sh /
