FROM registry.access.redhat.com/rhosp13/openstack-horizon:latest
MAINTAINER Big Switch Networks Inc <rhosp-bugs-internal@bigswitch.com>
LABEL name="rhosp13/openstack-horizon-bigswitch" \
      maintainer="rhosp-bugs-internal@bigswitch.com" \
      vendor="Big Switch Networks Inc" \
      version="13.0" \
      release="1" \
      summary="Red Hat OpenStack Platform 13.0 Horizon Big Switch Networks Plugin" \
      description="Red Hat OpenStack Platform 13.0 Horizon Big Switch Networks Plugin"

RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "/tmp/get-pip.py"
RUN python /tmp/get-pip.py
RUN pip install --upgrade "python-bsn-neutronclient"
RUN pip install --upgrade "horizon-bsn>=12.0.0,<12.1.0"
# copy enabled files
RUN cp /usr/lib/python2.7/site-packages/horizon_bsn/enabled/* /usr/lib/python2.7/site-packages/openstack_dashboard/local/enabled/
# copy License
RUN mkdir /licenses
RUN curl -L -o /licenses/LICENSE https://raw.githubusercontent.com/bigswitch/horizon-bsn/master/LICENSE
