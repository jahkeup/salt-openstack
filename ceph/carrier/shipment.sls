# This directory is intended for use in Dockerfile via a:
# (assuming you're building in /srv/container/cinder)
# ADD ../ceph/conf/ /etc/ceph
#
{% set staging = "/srv/container/ceph/conf" %}
{% include 'openstack/ceph/carrier/shipment.jinja' %}