FROM debian:buster

COPY  setup-gcsfuse.sh .
RUN ./setup-gcsfuse.sh

COPY  setup-reprepreo.sh .
RUN ./setup-reprepreo.sh

RUN mkdir -p /etc/autofs && touch /etc/autofs/auto.gcsfuse

ADD auto.master /etc/auto.master

WORKDIR /mnt

VOLUME /mnt
VOLUME /etc/gcloud
VOLUME /etc/autofs

ENV GOOGLE_APPLICATION_CREDENTIALS /etc/gcloud/service-account.json

CMD ["/usr/sbin/automount", "-t", "0", "-f", "/etc/auto.master"]
