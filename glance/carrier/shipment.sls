{% set staging = "/srv/container" %}
include:
  - openstack.glance.conf
extend:
  /etc/glance:
    file.directory:
      - name: {{staging}}/glance

  /etc/glance/glance-api.conf:
    file.managed:
      - name: {{staging}}/glance/glance-api.conf

  /etc/glance/glance-registry.conf:
    file.managed:
      - name: {{staging}}/glance/glance-registry.conf