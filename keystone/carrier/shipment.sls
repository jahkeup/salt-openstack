{% set staging = "/srv/container/keystone/conf" %}
include:
    - openstack.keystone.conf
extend:
  /etc/keystone:
    file.directory:
      - name: {{staging}}
      - makedirs: True

  /etc/keystone/keystone.conf:
    file.managed:
      - name: {{staging}}/keystone.conf

  keystonerc:
    file.managed:
      - name: {{staging}}/keystonerc