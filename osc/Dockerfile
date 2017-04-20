FROM debian:jessie-slim
RUN apt-get update \
    && apt-get install -y \
    python python-dev python-pip \
    && rm -rf /var/lib/apt/lists/*
RUN pip install pip
RUN pip install setuptools pytz
RUN pip install python-openstackclient
ENTRYPOINT ["openstack"]
