include:
  - openstack.keystone.user
  - openstack.database.client
  - openstack.database.python

keystone:
  pkg.installed:
    - pkgs:
        - keystone
        - python-keystone
        - python-keystoneclient
    - require:
        - user: keystone
        - pkg: openstack-database-python
  file.managed:
    - name: /etc/keystone/keystone.conf
    - source: salt://openstack/keystone/conf/keystone.conf
    - template: jinja
    - user: keystone
    - group: keystone
    - require: 
      - user: keystone
      - pkg: keystone