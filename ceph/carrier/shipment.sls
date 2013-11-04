# This state will need to be refactored into a template of sorts that can
# be included into the other shipments as needed. NOT meant for solo use.
include:
  - openstack.ceph.keys
  - openstack.ceph.conf

{% set ceph = pillar['openstack']['ceph'] %}
extend:
  ceph-dir:
    file.directory:
      - name: {{ceph_staging}}

  {% for client in ['instances','glance','cinder'] %}
  ceph-{{ ceph[client]['user'] }}-key:
    file.managed:
      - name: {{ceph_staging}}/ceph/ceph.client.{{ceph[client]['user']}}.keyring

  ceph-{{ceph[client]['user']}}-secret:
    file.managed:
      - name: {{ceph_staging}}/ceph/ceph.client.{{ceph[client]['user']}}.secret
  {% endfor %}

  ceph-conf-only:
    file.managed:
      - name: {{ceph_staging}}/ceph/ceph.conf