include:
  - openstack.ceph.repo
  - openstack.ceph.keys
  - openstack.patch.kombu
  - openstack.cinder.user
  - openstack.cinder.conf

cinder-ceph-integration:
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
    - require_in:
      - file: /etc/cinder/cinder.conf
    - require:
      - user: cinder-user
      - pkg: cinder-ceph-integration
      - sls: openstack.patch.kombu
  service.running:
    - watch:
      - file: '/etc/cinder/cinder.conf'
      - pkg: cinder-{{subservice}}
      - cmd: cinder-service-cephargs
      - file: '/etc/cinder/api-paste.ini'
    - require:
      - file: '/etc/cinder/api-paste.ini'
      - cmd: cinder-db-sync
      - file: '/etc/cinder/cinder.conf'
      - pkg: cinder-{{subservice}}
{% endfor %}

cinder-client:
  pkg.installed:
    - pkgs:
        - python-cinder
        - python-cinderclient
    - require:
      - pkg: cinder-api

cinder-db-sync:
  cmd.wait:
    - name: cinder-manage db sync
    - require:
      - pkg: cinder-api
    - watch:
      - pkg: cinder-api

cinder-service-cephargs:
  cmd.wait:
    - name: sed -i '1ienv CEPH_ARGS="--id volumes"' /etc/init/cinder-volume.conf
    - require:
      - pkg: cinder-volume
    - watch:
      - pkg: cinder-volume

