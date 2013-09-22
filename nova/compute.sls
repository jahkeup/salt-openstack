include:
  - openstack.repo
  - openstack.ceph.repo
  - openstack.nova.user
  - openstack.nova.conf

ceph-fs:
  pkg.installed:
    - pkgs:
      - python-ceph
      - ceph-common
      - ceph-fs-common
      - rbd-fuse
    - require:
      - pkgrepo: ceph-repo

nova-compute-kvm:
  pkg.installed:
    - require:
      - user: nova-user
      - pkg: ceph-fs

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