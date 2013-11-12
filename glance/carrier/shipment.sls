{% set staging = "/srv/container/glance/conf" %}
include:
  - openstack.glance.conf
  - openstack.glance.carrier.ceph-shipment

extend:
  /etc/glance:
    file.directory:
      - name: {{staging}}
      - makedirs: True

  /etc/glance/glance-api.conf:
    file.managed:
      - name: {{staging}}/glance-api.conf

  /etc/glance/glance-registry.conf:
    file.managed:
      - name: {{staging}}/glance-registry.conf

