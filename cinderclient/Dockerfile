FROM debian:jessie-slim

RUN apt-get update && apt install -y \
  --no-install-recommends software-properties-common \
  python-pip git python-dev python-setuptools gcc\
  && rm -rf /var/lib/apt/lists/*
RUN pip install -U pip setuptools
RUN git clone https://github.com/openstack/python-cinderclient \
  && cd python-cinderclient \
  && pip install -r requirements.txt \
  && pip install .
RUN cd ../ && rm -rf python-cinderclient && apt-get remove -y git gcc
ENTRYPOINT ["cinder"]
