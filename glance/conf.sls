include:
  - openstack.glance.user

/etc/glance:
  file.directory:
    - mode: 755
    - user: glance
    - group: glance
    - require:
      - user: glance-user

/etc/glance/glance-api.conf:
  file.managed:
    - name: /etc/glance/glance-api.conf
    - user: glance
    - group: glance
    - source: salt://openstack/glance/conf/glance-api.conf
    - template: jinja
    - require:
      - file: /etc/glance

/etc/glance/glance-registry.conf:
  file.managed:
    - name: /etc/glance/glance-registry.conf
    - user: glance
    - group: glance
    - source: salt://openstack/glance/conf/glance-registry.conf
    - template: jinja
    - require:
      - file: /etc/glance
