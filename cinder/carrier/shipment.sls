{% set staging = "/srv/container/cinder/conf" %}
include:
  - openstack.cinder.conf
  - openstack.cinder.carrier.ceph-shipment

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
