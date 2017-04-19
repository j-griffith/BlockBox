#!/bin/bash
export ADMIN_PASS=password

# we'll need to make sure the pymsql var is set right in the conf

/bin/sh -c "keystone-manage db_sync" keystone
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone \
    --keystone-group keystone

keystone-manage bootstrap --bootstrap-password $ADMIN_PASS \
  --bootstrap-admin-url http://$HOSTNAME:35357/v3/ \
  --bootstrap-internal-url http://$HOSTNAME:5000/v3/ \
  --bootstrap-public-url http://$HOSTNAME:5000/v3/ \
  --bootstrap-region-id RegionOne
service apache2 restart

# TODO
# create the service stuff
# create the endpoints and users while we're at it
# add host to the apache2 conf file if needed
touch /var/log/keystone/keystone.log
tail -f /var/log/keystone/keystone.log
