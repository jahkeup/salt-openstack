include:
  - openstack.repo

nova-compute-kvm:
  pkg.installed:
    - order: 3

nova-compute:
  service.running:
    - enable: True
    - require:
      - pkg: nova-compute-kvm
/etc/nova:
  file.directory:
    - user: nova
    - group: nova
    - require:
      - pkg: nova-compute-kvm
