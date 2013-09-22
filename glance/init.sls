include:
  - openstack.repo
  - openstack.ceph.repo
  - openstack.patch.kombu
  - openstack.glance.user
  - openstack.keystone.python

ceph-integration:
  pkg.installed:
    - pkgs:
      - python-ceph
      - ceph-common
    - require:
      - pkgrepo: ceph-repo

/etc/glance:
  file.directory:
    - user: glance
    - group: glance
    - require:
      - pkg: glance-api

glance-api:
  pkg.installed:
    - require:
      - user: glance-user
      - pkg: python-keystone
      - pkg: ceph-integration
      - sls: openstack.patch.kombu
  service.running:
    - enable: True
    - require:
      - pkg: glance-api
      - cmd: glance-db-sync
    - watch:
      - file: glance-api-conf

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
      - pkg: ceph-integration
      - pkg: python-keystone
  service.running:
    - enable: True
    - require:
      - pkg: glance-registry
    - watch:
      - file: glance-registry-conf

glance-api-conf:
  file.managed:
    - name: /etc/glance/glance-api.conf
    - user: glance
    - group: glance
    - source: salt://openstack/glance/conf/glance-api.conf
    - template: jinja
    - require: 
      - pkg: glance-api

glance-registry-conf:
  file.managed:
    - name: /etc/glance/glance-registry.conf
    - user: glance
    - group: glance
    - source: salt://openstack/glance/conf/glance-registry.conf
    - template: jinja
    - require:
      - pkg: glance-registry
