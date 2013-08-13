include:
  - openstack.repo
  - openstack.nova.conf

nova-compute-kvm:
  pkg.installed:

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
