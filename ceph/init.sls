include:
  - openstack.ceph.repo

ceph:
  pkg.installed:
    - pkgs:
      - ceph
      - ceph-mds
      - ceph-fs-common
    - require:
      - pkgrepo: ceph-repo
ceph-example-conf:
  file.managed:
    - name: /etc/ceph/ceph.conf-example
    - mode: 444
    - source: salt://openstack/ceph/conf/ceph.conf
    - require:
      - pkg: ceph