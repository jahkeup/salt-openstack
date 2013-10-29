{% set staging = "/srv/container" %}
include:
  - openstack.cinder.conf

extend:
  '/etc/cinder':
    file.directory:
      - name: {{staging}}/cinder

  '/etc/cinder/cinder.conf':
    file.managed:
      - name: {{staging}}/cinder/cinder.conf

  '/etc/cinder/api-paste.ini':
    file.managed:
      - name: {{staging}}/cinder/api-paste.ini
