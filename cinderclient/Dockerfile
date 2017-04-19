FROM ubuntu:xenial

RUN apt-get update && apt install -y \
  --no-install-recommends software-properties-common \
  python-pip vim git python-dev python-setuptools gcc\
  && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/openstack/python-cinderclient \
  && cd python-cinderclient \
  && pip install -r requirements.txt \
  && pip install -e .
RUN apt-get remove -y git gcc
CMD touch dumb && tail -f dumb

