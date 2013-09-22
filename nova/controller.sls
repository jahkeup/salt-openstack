include:
  - openstack.repo
  - openstack.patch.kombu
  - openstack.nova.conf

nova-api:
  pkg.installed:
    - require:
      - user: nova-user
      - sls: openstack.patch.kombu
  service.running:
    - enable: True
    - require:
      - pkg: nova-api
      - cmd: nova-db-sync
    - watch:
      - cmd: nova-db-sync
      - file: '/etc/nova/nova.conf'
      - file: '/etc/nova/api-paste.ini'

nova-db-sync:
  cmd.wait:
    - name: nova-manage db sync
    - require:
      - pkg: nova-api
    - watch:
      - pkg: nova-api

nova-client:
  pkg.installed:
    - pkgs:
      - python-nova
      - python-novaclient

nova-conductor:
  pkg:
    - installed
  service.running:
    - enable: True
    - require:
      - pkg: nova-conductor
      - user: nova-user
    - watch:
      - pkg: nova-conductor
      - service: nova-api

nova-scheduler:
  pkg.installed:
    - require:
      - user: nova-user
  service.running:
    - enable: True
    - require:
      - pkg: nova-scheduler
    - watch:
      - pkg: nova-scheduler
      - service: nova-api