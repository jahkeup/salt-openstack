include:
  - openstack.keystone.user

keystone:
  pkg.installed:
    - pkgs:
        - keystone
        - python-keystone
        - python-keystoneclient
    - require:
        - user: keystone
  