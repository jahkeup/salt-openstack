{% set staging = "/srv/container" %}
include:
  - openstack.ceph.keys
  - openstack.ceph.conf

{% set ceph = pillar['openstack']['ceph'] %}
extend:
  ceph-dir:
    file.directory:
      - name: {{staging}}/ceph

  {% for client in ['instances','glance','cinder'] %}
  ceph-{{ ceph[client]['user'] }}-key:
    file.managed:
      - name: {{staging}}/ceph/ceph.client.{{ ceph[client]['user'] }}.keyring

  ceph-{{ceph[client]['user']}}-secret:
    file.managed:
      - name: {{staging}}/ceph/ceph.client.{{ceph[client]['user']}}.secret
  {% endfor %}

  ceph-conf-only:
    file.managed:
      - name: {{staging}}/ceph/ceph.conf