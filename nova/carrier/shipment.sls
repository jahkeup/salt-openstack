{% set staging = "/srv/container/nova/conf" %}
include:
  - openstack.nova.conf

extend:
  '/etc/nova':
    file.directory:
      - name: {{staging}}
      - makedirs: True

  {% for conf in ['nova.conf','api-paste.ini','policy.json'] %}
  '/etc/nova/{{conf}}':
    file.managed:
      - name: {{staging}}/{{conf}}
  {% endfor %}