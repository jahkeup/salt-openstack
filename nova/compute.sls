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
  - openstack.nova.override
  - openstack.nova.fstab

nfs-client:
  pkg.installed:
    - name: nfs-common

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
      - pkg: nfs-client
      - sls: openstack.patch.kombu
      - file: '/etc/nova'

nova-compute:
  service.running:
    - enable: True
    - require:
      - pkg: nfs-client
      - pkg: nova-compute-kvm
      - cmd: nova-volumes-secret
