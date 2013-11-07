{% set staging = "/srv/container/cinder/conf" %}
include:
  - openstack.cinder.conf

extend:
  '/etc/cinder':
    file.directory:
      - name: {{staging}}
      - makedirs: True

  '/etc/cinder/cinder.conf':
    file.managed:
      - name: {{staging}}/cinder.conf

  '/etc/cinder/api-paste.ini':
    file.managed:
      - name: {{staging}}/api-paste.ini

{% set staging = "/srv/container/cinder/ceph" %}
{% include 'openstack/ceph/carrier/shipment.jinja' %}
