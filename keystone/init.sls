include:
  - openstack.keystone.user
  - openstack.database.client
  - openstack.database.python
  - openstack.database.keystone

extend:
  keystone:
    pkg.installed:
      - pkgs:
          - keystone
          - python-keystone
          - python-keystoneclient
      - require:
          - user: keystone
          - pkg: openstack-database-python
          - mysql_grants: keystone-database-grant
    file.managed:
      - name: /etc/keystone/keystone.conf
      - source: salt://openstack/keystone/conf/keystone.conf
      - template: jinja
      - user: keystone
      - group: keystone
      - require: 
        - user: keystone
        - pkg: keystone

sync-keystone-db:
  cmd.wait:
    - name: "keystone-manage db_sync"
    - watch:
        - pkg: keystone
        - file: keystone
    - require:
        - pkg: keystone 
        - file: keystone