{% set staging = "/srv/container" %}
include:
    - openstack.keystone.conf
extend:
  /etc/keystone:
    file.directory:
      - name: {{staging}}/keystone

  /etc/keystone/keystone.conf:
    file.managed:
      - name: {{staging}}/keystone/keystone.conf

  keystonerc:
    file.managed:
      - name: {{staging}}/keystonerc