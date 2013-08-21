{% set ceph = pillar['openstack']['ceph'] %}
include: 
  - ceph.client

ceph-keys:
  file.directory:
    - name: /etc/ceph

{% for client in ['nova'] %}
ceph-{{ ceph[client]['user'] }}-key:
  file.managed:
    - name: /etc/ceph/client.{{ ceph[client]['user'] }}.secret
    - contents: {{ ceph[client]['key'] }}
    - require:
        - file: ceph-keys
  
{% endfor %}
