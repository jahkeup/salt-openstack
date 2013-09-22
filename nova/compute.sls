{% set openstack = pillar['openstack'] -%}
{% set ceph = openstack['ceph'] -%}
{% set cephfs = openstack['ceph']['instances'] -%}
{% set images = ceph['images'] -%}
{% set volumes = ceph['cinder'] -%}

include:
  - openstack.repo
  - openstack.ceph.repo
  - openstack.ceph.keys
  - openstack.patch.kombu
  - openstack.nova.user
  - openstack.nova.conf

ceph-fs:
  pkg.installed:
    - pkgs:
      - python-ceph
      - ceph-common
      - ceph-fs-common
      - rbd-fuse
    - require:
      - pkgrepo: ceph-repo
  cmd.run:
    - name: mount /var/lib/nova/instances
    - require:
      - cmd: ceph-fs-fstab
      - file: ceph-{{cephfs['user']}}-key
      - pkg: nova-compute-kvm

ceph-fs-fstab:
  cmd.wait:
    - name: >-
        cp /etc/fstab /etc/fstab.bak && echo 
        "{{ceph['mon']}}:{{cephfs['path']}} /var/lib/nova/instances ceph name={{cephfs['user']}},secretfile=/etc/ceph/ceph.client.{{cephfs['user']}}.secret 0 0" 
        >> /etc/fstab
    - require:
      - pkg: ceph-fs
    - watch: 
      - pkg: ceph-fs

nova-volumes-secret:
  file.managed:
    - name: /etc/nova/libvirt-volumes-secret.xml
    - source: salt://openstack/nova/conf/libvirt-secret.xml
    - template: jinja
    - context:
        uuid: {{volumes['uuid']}}
        user: {{volumes['user']}}
    - require:
      - pkg: nova-compute-kvm
      - file: ceph-{{volumes['user']}}-secret
  cmd.wait:
    - name: >-
        virsh secret-define --file /etc/nova/libvirt-volumes-secret.xml &&
        virsh secret-set-value --secret {{volumes['uuid']}} --base64 \
          $(cat /etc/ceph/ceph.client.{{volumes['user']}}.secret)
    - require:
      - file: nova-volumes-secret
    - watch:
      - file: nova-volumes-secret
    

nova-compute-kvm:
  pkg.installed:
    - require:
      - user: nova-user
      - pkg: ceph-fs
      - sls: openstack.patch.kombu
      - file: '/etc/nova'

nova-compute:
  service.running:
    - enable: True
    - require:
      - pkg: nova-compute-kvm
      - cmd: ceph-fs
      - cmd: nova-volumes-secret
