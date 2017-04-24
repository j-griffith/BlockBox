# openstack-eystone with osc in a box
# docker run -d \
#    -p 5000:5000 \
#    -p 35357:35357 \
#    --link dbhost \
#    -e DB_PASSWORD=password
#    -e OS_PASSWORD=password
#    -e DEMO_PASSWORD=password
#    -e DB_HOST=dbhost

FROM ubuntu:17.04

COPY ./setup.sh /setup.sh
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
&& apt-get install -y vim keystone python-openstackclient \
&& rm -rf /var/lib/apt
CMD ./setup.sh && sleep 5 && tail -f /var/log/apache2/keystone.log
