ceph-conf-only:
  file.present:
    - name: /etc/ceph/ceph.conf
      # This file MUST be created locally. This is per env.
    - source: salt://openstack/ceph/local/ceph.conf
    - mode: 444