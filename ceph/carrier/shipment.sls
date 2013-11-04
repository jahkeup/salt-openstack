# This directory is intended for use in Dockerfile via a:
# (assuming you're building in /srv/container/cinder)
# ADD ../ceph/conf/ /etc/ceph
#
{% set staging = "/srv/container/ceph/conf" %}
include:
  - openstack.ceph.keys
  - openstack.ceph.conf

{% set ceph = pillar['openstack']['ceph'] %}
extend:
  ceph-dir:
    file.directory:
      - name: {{staging}}
      - makedirs: True

  {% for client in ['instances','glance','cinder'] %}
  ceph-{{ ceph[client]['user'] }}-key:
    file.managed:
      - name: {{staging}}/ceph.client.{{ceph[client]['user']}}.keyring

  ceph-{{ceph[client]['user']}}-secret:
    file.managed:
      - name: {{staging}}/ceph.client.{{ceph[client]['user']}}.secret
  {% endfor %}

  ceph-conf-only:
    file.managed:
      - name: {{staging}}/ceph.conf