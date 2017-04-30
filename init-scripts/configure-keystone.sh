export OS_USERNAME=admin
export OS_PASSWORD=password
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://keystone:35357/v3
export OS_IDENTITY_API_VERSION=3

openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default --password $OS_PASSWORD demo
openstack role create user
openstack role add --project demo --user demo user


#openstack service create  --name keystone identity
#openstack endpoint create --region RegionOne identity public http://keystone:5000/v3
#openstack endpoint create --region RegionOne identity internal http://keystone:5000/v3
#openstack endpoint create --region RegionOne identity admin http://keystone:5000/v3
#openstack domain create --description "Default Domain" default
#openstack project create --domain default  --description "Admin Project" admin
#openstack user create --domain default --password $ADMIN_PASSWORD admin
#openstack role create admin
#openstack role add --project admin --user admin admin
