FROM ubuntu:xenial

RUN apt-get update && apt install -y \
  --no-install-recommends software-properties-common \
  && add-apt-repository cloud-archive:ocata \
  && apt-get update \
  && apt install -y --no-install-recommends cinder-api vim \
  && rm -rf /var/lib/apt/lists/*
CMD service apache2 restart \
  && touch /var/log/apache2/cinder.log \
  && tail -f /var/log/apache2/cinder.log
