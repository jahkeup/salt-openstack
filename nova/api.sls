include:
  - openstack.repo
  - openstack.nova.conf
  - openstack.nova.common

nova-api:
  pkg:
    - installed

  service.running:
    - enable: True
    - require:
      - pkg: nova-api
    - watch:
        - file: '/etc/nova/nova.conf'
        - file: '/etc/nova/api-paste.ini'

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
    - watch:
        - pkg: nova-conductor
        - service: nova-api

nova-scheduler:
  pkg:
    - installed
  service.running:
    - enable: True
    - require:
        - pkg: nova-scheduler
    - watch:
        - pkg: nova-scheduler
        - service: nova-api