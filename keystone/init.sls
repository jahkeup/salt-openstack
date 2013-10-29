# This state assumes that the database is already installed &
# provisioned, this also includes the necessary grants and users. The
# installation will succeed if the database isn't configured however,
# the services will fail to remain started and will throw errors in
# /var/log/keystone

include:
  - openstack.patch.kombu
  - openstack.keystone.user
  - openstack.keystone.conf

keystone:
  pkg.installed:
    - pkgs:
      - memcached
      - python-memcache
      - keystone
      - python-keystone
      - python-mysqldb
      - python-keystoneclient
    - require:
      - sls: openstack.patch.kombu
      - user: keystone-user
    - require_in:
      - file: /etc/keystone/keystone.conf

  service.running:
    - enable: True
    - require:
      - file: /etc/keystone/keystone.conf
      - pkg: keystone
    - watch:
      - file: /etc/keystone/keystone.conf
      - cmd: sync-keystone-db

sync-keystone-db:
  cmd.wait:
    - name: "keystone-manage db_sync"
    - watch:
      - pkg: keystone
      - file: keystone
    - require:
      - pkg: keystone
      - file: keystone