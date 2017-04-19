FROM ubuntu:xenial

RUN apt-get update && apt install -y \
  --no-install-recommends software-properties-common \
  && add-apt-repository cloud-archive:ocata \
  && apt-get update \
  && apt install -y --no-install-recommends cinder-volume vim \
  && rm -rf /var/lib/apt/lists/*
CMD service cinder-volume start && sleep 3 && \
  tail -f /var/log/cinder/cinder-volume.log
