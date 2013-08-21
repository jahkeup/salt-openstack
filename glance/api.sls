include:
  - openstack.glance.user

/etc/glance:
  file.directory:
    - user: glance
    - group: glance
    - require:
      - user: glance
      - pkg: glance-api

glance-api:
  pkg.installed:
    - require:
        - user: glance
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
  service.running:
    - enable: True
    - require:
        - pkg: glance-registry
    - watch:
        - file: glance-registry-conf

glance-api-conf:
  file.managed:
    - name: /etc/glance/glance-api.conf
    - source: salt://openstack/glance/conf/glance-api.conf
    - require: 
        - pkg: glance-api

glance-registry-conf:
  file.managed:
    - name: /etc/glance/glance-registry.conf
    - source: salt://openstack/glance/conf/glance-registry.conf
    - template: jinja
    - require:
        - pkg: glance-registry
