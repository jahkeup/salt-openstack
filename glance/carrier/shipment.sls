{% set prefix = "/srv/container" %}
include:
  - openstack.glance.user

glance-api-conf:
  file.managed:
    - name: {{prefix}}/glance/glance-api.conf
    - user: glance
    - group: glance
    - source: salt://openstack/glance/conf/glance-api.conf
    - template: jinja

glance-registry-conf:
  file.managed:
    - name: {{prefix}}/glance/glance-registry.conf
    - user: glance
    - group: glance
    - source: salt://openstack/glance/conf/glance-registry.conf
    - template: jinja
