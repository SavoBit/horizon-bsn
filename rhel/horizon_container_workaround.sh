#!/bin/bash -eux

CONTAINER_BUILD_DIR='openstack_horizon_bigswitch'

# recreate worksapace for container build
rm -rf ${CONTAINER_BUILD_DIR}
mkdir -p ${CONTAINER_BUILD_DIR}

# copy required packages to build dir
cp python-horizon-bsn-*.rpm ${CONTAINER_BUILD_DIR}/
curl -O "http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/p/python-lockfile-0.9.1-4.el7.noarch.rpm"
cp python-lockfile*.rpm ${CONTAINER_BUILD_DIR}/

# container tag_id used to deploy overcloud
UPSTREAM_TAG=`sudo openstack overcloud container image tag discover \
--image registry.access.redhat.com/rhosp12/openstack-base:latest \
--tag-from-label version-release`

# local registry address to push image
LOCAL_REGISTRY_ADDRESS=`docker images | grep -v redhat.com | grep -o '^.*rhosp12' | sort -u`

cd ${CONTAINER_BUILD_DIR}

cat > Dockerfile <<EOF
FROM ${LOCAL_REGISTRY_ADDRESS}/openstack-horizon:${UPSTREAM_TAG}
MAINTAINER Big Switch Networks Inc.
LABEL name="rhosp12/openstack-horizon-bigswitch" vendor="Big Switch Networks Inc" version="11.0" release="1"

# switch to root and install a custom RPM, etc.
USER root
COPY python-horizon-bsn*.rpm /tmp/
COPY python-lockfile*.rpm /tmp/
RUN rpm -ivh /tmp/*.rpm
RUN cp /usr/lib/python2.7/site-packages/horizon_bsn/enabled/* /usr/lib/python2.7/site-packages/openstack_dashboard/local/enabled/
# switch the container back to the default user (NOT)
# doing this has permission denied error during startup. skip it.
# USER horizon
EOF

sudo docker build ./ -t latest_bsn_tag
IMAGE_ID=`sudo docker images -q latest_bsn_tag`

# tag latest build image and push to local registry
sudo docker tag ${IMAGE_ID} ${LOCAL_REGISTRY_ADDRESS}/openstack-horizon-bigswitch:latest_bsn_tag
sudo docker push ${LOCAL_REGISTRY_ADDRESS}/openstack-horizon-bigswitch:latest_bsn_tag
