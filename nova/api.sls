include:
  - openstack.repo
  - openstack.nova.conf
  - openstack.nova.common
  - openstack.nova.tools
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