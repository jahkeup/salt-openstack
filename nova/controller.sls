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
nova-cert:
  pkg.installed:
    - require:
      - pkg: nova-api
  service.running:
    - enable: True
    - require:
      - pkg: nova-cert

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
nova-consoleauth:
  pkg.installed:
  - require:
    - pkg: nova-api
    - cmd: nova-db-sync
  service.running:
    - require:
      - pkg: nova-consoleauth
    - watch:
      - file: '/etc/nova/nova.conf'

nova-novncproxy:
  pkg.installed:
    - require:
      - pkg: nova-consoleauth
      - pkg: nova-api
      - file: '/etc/nova/nova.conf'
  service.running:
    - require:
      - pkg: nova-novncproxy
    - watch:
      - file: '/etc/nova/nova.conf'

nova-conductor:
  pkg.installed:
    - require:
      - pkg: nova-api
      - cmd: nova-db-sync
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
      - cmd: nova-db-sync
      - pkg: nova-api
  service.running:
    - enable: True
    - require:
      - pkg: nova-scheduler
    - watch:
      - pkg: nova-scheduler
      - service: nova-api