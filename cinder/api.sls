include:
  - openstack.repo
  - openstack.cinder.user

{% for subservice in ['api','scheduler','volume'] %}
cinder-{{subservice}}:
  pkg.installed:
    - require:
        - user: cinder

  service.running:
    - watch:
      - file: '/etc/cinder/cinder.conf'
      - file: '/etc/cinder/api-paste.ini'
      - pkg: cinder-{{subservice}}
    - require:
      - file: '/etc/cinder/cinder.conf'
      - file: '/etc/cinder/api-paste.ini'
      - pkg: cinder-{{subservice}}
{% endfor %}

'/etc/cinder/cinder.conf':
  file.managed:
    - source: salt://openstack/cinder/conf/cinder.conf
    - template: jinja
    - user: cinder
    - group: cinder
    - require:
        - user: cinder
        - pkg: cinder-api

/etc/cinder/cinder.conf:
  file.managed:
    - source: salt://openstack/cinder/conf/api-paste.ini
    - template: jinja
    - user: cinder
    - group: cinder
    - require:
        - user: cinder
        - pkg: cinder-api