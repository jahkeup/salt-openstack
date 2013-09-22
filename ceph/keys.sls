{% set ceph = pillar['openstack']['ceph'] %}
ceph-dir:
  file.directory:
    - name: /etc/ceph

{% for client in ['instances','glance','cinder'] %}
ceph-{{ ceph[client]['user'] }}-key:
  file.managed:
    - name: /etc/ceph/ceph.client.{{ ceph[client]['user'] }}.keyring
    - mode: 444
    - contents: |
        [client.{{ceph[client]['user']}}]
          key = {{ ceph[client]['key'] }}
          
    - require:
        - file: ceph-dir
        - file: ceph-{{ceph[client]['user']}}-secret

ceph-{{ceph[client]['user']}}-secret:
  file.managed:
    - name: /etc/ceph/ceph.client.{{ceph[client]['user']}}.secret
    - mode: 444
    - contents: {{ceph[client]['key']}}
    - require:
      - file: ceph-dir
{% endfor %}
