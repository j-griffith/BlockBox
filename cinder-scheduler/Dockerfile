FROM ubuntu:xenial

RUN apt-get update && apt install -y \
  --no-install-recommends software-properties-common \
  && add-apt-repository cloud-archive:ocata \
  && apt-get update \
  && apt install -y --no-install-recommends cinder-scheduler vim \
  && rm -rf /var/lib/apt/lists/*
CMD service cinder-scheduler start && sleep 3 && \
  tail -f /var/log/cinder/cinder-scheduler.log
