{% set staging = "/srv/container/cinder/conf" %}
include:
  - openstack.glance.conf
extend:
  /etc/glance:
    file.directory:
      - name: {{staging}}/glance
      - makedirs: True

  /etc/glance/glance-api.conf:
    file.managed:
      - name: {{staging}}/glance/glance-api.conf

  /etc/glance/glance-registry.conf:
    file.managed:
      - name: {{staging}}/glance/glance-registry.conf