include:
  - openstack.cinder.user

'/etc/cinder':
  file.directory:
    - mode: 755
    - user: cinder
    - group: cinder
    - require:
      - user: cinder-user

'/etc/cinder/cinder.conf':
  file.managed:
    - source: salt://openstack/cinder/conf/cinder.conf
    - template: jinja
    - user: cinder
    - group: cinder
    - require:
      - file: '/etc/cinder'

'/etc/cinder/api-paste.ini':
  file.managed:
    - source: salt://openstack/cinder/conf/api-paste.ini
    - template: jinja
    - user: cinder
    - group: cinder
    - require:
      - file: '/etc/cinder'
