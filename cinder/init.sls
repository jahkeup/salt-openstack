include:
  - openstack.repo
  - openstack.ceph.repo
  - openstack.ceph.keys
  - openstack.cinder.user

ceph-integration:
  pkg.installed:
    - pkgs:
      - python-ceph
      - ceph-common
    - require:
      - pkgrepo: ceph-repo
      - sls: openstack.ceph.keys  

{% for subservice in ['api','scheduler','volume'] %}
cinder-{{subservice}}:
  pkg.installed:
    - require:
      - user: cinder-user
      - pkg: ceph-integration
  service.running:
    - watch:
      - file: '/etc/cinder/cinder.conf'
      - pkg: cinder-{{subservice}}
      - cmd: cinder-service-cephargs
    - require:
      - file: '/etc/cinder/cinder.conf'
      - pkg: cinder-{{subservice}}
{% endfor %}

cinder-service-cephargs:
  cmd.wait:
    - name: sed -i '1ienv CEPH_ARGS="--id volumes"' /etc/init/cinder-volume.conf 
    - require:
      - pkg: cinder-volume
    - watch:
      - pkg: cinder-volume

'/etc/cinder/cinder.conf':
  file.managed:
    - source: salt://openstack/cinder/conf/cinder.conf
    - template: jinja
    - user: cinder
    - group: cinder
    - require:
      - pkg: cinder-api

/etc/cinder/cinder.conf:
  file.managed:
    - source: salt://openstack/cinder/conf/cinder.conf
    - template: jinja
    - user: cinder
    - group: cinder
    - require:
      - user: cinder
      - pkg: cinder-api
