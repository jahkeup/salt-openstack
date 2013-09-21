include:
  - openstack.ceph.repo

ceph:
  pkg.installed:
    - pkgs:
      - ceph
      - ceph-mds
    - require:
      - pkgrepo: ceph-repo
