#!/bin/bash

sed -i "713i connection = mysql+pymysql://keystone:${DB_PASSWORD}@${DB_HOST}/keystone" \
  /etc/keystone/keystone.conf

/bin/sh -c "keystone-manage db_sync" keystone

keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone

keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

keystone-manage bootstrap --bootstrap-password ${OS_PASSWORD} --bootstrap-admin-url http://${HOSTNAME}:35357/v3/   --bootstrap-internal-url http://${HOSTNAME}:5000/v3/   --bootstrap-public-url http://${HOSTNAME}:5000/v3/   --bootstrap-region-id RegionOne

sed -i "54i ServerName ${HOSTNAME}" /etc/apache2/apache2.conf
service apache2 restart
rm -f /var/lib/keystone/keystone.db

export OS_USERNAME=admin
export OS_PASSWORD=${OS_PASSWORD}
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://${HOSTNAME}:35357/v3
export OS_IDENTITY_API_VERSION=3

openstack project create --domain default \
  --description "Service Project" service

openstack project create --domain default \
  --description "Demo Project" demo

openstack user create --domain default \
  --password ${DEMO_PASSWORD} demo

openstack role create user

openstack role add --project demo --user demo user

openstack --os-auth-url http://${HOSTNAME}:35357/v3 \
  --os-project-domain-name default --os-user-domain-name default \
  --os-project-name admin --os-username admin token issue

openstack --os-auth-url http://${HOSTNAME}:5000/v3 \
  --os-project-domain-name default --os-user-domain-name default \
  --os-project-name demo --os-username demo token issue
