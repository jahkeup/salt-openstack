include:
  - openstack.repo
  - openstack.nova.conf

nova-api:
  pkg:
    - installed

  service.running:
    - enable: True
    - require:
      - pkg: nova-api

/etc/nova:
  file.directory:
    - user: nova
    - group: nova
    - require:
      - pkg: nova-api