include:
  - openstack.repo
  - openstack.cinder.user

cinder-api:
  pkg.installed:
    - require:
        - user: cinder

cinder-common:
  pkg.installed:
    - require:
        - pkg: cinder-api

cinder-client:
  pkg.installed:
    - pkgs:
        - python-cinder
        - python-cinderclient

'/etc/cinder/cinder.conf':
  file.managed:
    - source: salt://openstack/cinder/conf/cinder.conf
    - template: jinja
    - user: cinder
    - group: cinder
    - require:
        - user: cinder
        - pkg: cinder-api

