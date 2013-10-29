include:
  - openstack.ceph.repo
  - openstack.patch.kombu
  - openstack.glance.user
  - openstack.glance.conf
  - openstack.keystone.python

glance-ceph-integration:
  pkg.installed:
    - pkgs:
      - python-ceph
      - ceph-common
    - require:
      - pkgrepo: ceph-repo

glance-api:
  pkg.installed:
    - require:
      - user: glance-user
      - pkg: python-keystone
      - pkg: glance-ceph-integration
      - sls: openstack.patch.kombu
  service.running:
    - enable: True
    - require:
      - pkg: glance-api
      - file: /etc/glance/glance-api.conf
      - cmd: glance-db-sync
    - watch:
      - file: /etc/glance/glance-api.conf

glance-db-sync:
  cmd.wait:
    - name: glance-manage db_sync
    - require:
      - pkg: glance-api
    - watch:
      - pkg: glance-api

glance-registry:
  pkg.installed:
    - require:
      - user: glance
      - pkg: glance-ceph-integration
      - pkg: python-keystone
  service.running:
    - enable: True
    - require:
      - cmd: glance-db-sync
      - pkg: glance-registry
      - file: /etc/glance/glance-registry.conf
    - watch:
      - file: /etc/glance/glance-registry.conf
