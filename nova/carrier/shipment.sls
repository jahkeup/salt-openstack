{% set staging = "/srv/container" %}
include:
  - openstack.nova.conf

extend:
  '/etc/nova':
    file.directory:
      - name: {{staging}}/nova

  {% for conf in ['nova.conf','api-paste.ini','policy.json'] %}
  '/etc/nova/{{conf}}':
    file.managed:
      - name: {{staging}}/nova/{{conf}}
  {% endfor %}