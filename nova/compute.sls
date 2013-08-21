include:
  - openstack.repo
  - openstack.nova.user
  - openstack.nova.conf

nova-compute-kvm:
  pkg.installed:
    - require:
        - user: nova

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
      - user: nova
      - pkg: nova-compute-kvm