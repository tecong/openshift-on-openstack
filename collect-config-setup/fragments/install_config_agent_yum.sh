#!/bin/bash
set -eux

# on Atomic host os-collect-config runs inside a container which is
# fetched&started in another step
[ -e /run/ostree-booted ] && exit 0

if ! yum info os-collect-config; then
    # if os-collect-config package is not available, first check if
    # the repo is available but disabled, otherwise install the package
    # from epel
    if yum repolist disabled|grep rhel-7-server-openstack-8-director-rpms; then
        subscription-manager repos --enable="rhel-7-server-openstack-8-director-rpms"
        subscription-manager repos --enable="rhel-7-server-openstack-8-rpms"
    else
        yum -y install centos-release-openstack-liberty
    fi
fi
yum -y install os-collect-config python-zaqarclient os-refresh-config os-apply-config openstack-heat-templates python-oslo-log

# os-collect-config tunkki https://review.openstack.org/#/c/285959/
sed -i -e 's/verify=CONF.cfn.ca_certificate)/verify=False)/g' /lib/python2.7/site-packages/os_collect_config/cfn.py > ~/tunkki.log 2> ~/tunkki.log
# heat-config-notify tunkki
sed -i -e 's/headers={\x27content-type\x27: None})/headers={\x27content-type\x27: None}, verify=False)/g' /usr/share/openstack-heat-templates/software-config/elements/heat-config/bin/heat-config-notify >> ~/tunkki.log 2>> ~/tunkki.log
#yum-config-manager --disable 'epel*'
