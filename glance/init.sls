include:
  - openstack.repo
  - openstack.glance.user
  - openstack.keystone.python

/etc/glance:
  file.directory:
    - user: glance
    - group: glance
    - require:
      - pkg: glance-api

glance-api:
  pkg.installed:
    - require:
      - user: glance-user
      - pkg: python-keystone
  service.running:
    - enable: True
    - require:
      - pkg: glance-api
    - watch:
      - file: glance-api-conf

glance-registry:
  pkg.installed:
    - require:
      - user: glance
      - pkg: python-keystone
  service.running:
    - enable: True
    - require:
      - pkg: glance-registry
    - watch:
      - file: glance-registry-conf

glance-api-conf:
  file.managed:
    - name: /etc/glance/glance-api.conf
    - user: glance
    - group: glance
    - source: salt://openstack/glance/conf/glance-api.conf
    - template: jinja
    - require: 
      - pkg: glance-api

glance-registry-conf:
  file.managed:
    - name: /etc/glance/glance-registry.conf
    - user: glance
    - group: glance
    - source: salt://openstack/glance/conf/glance-registry.conf
    - template: jinja
    - require:
      - pkg: glance-registry