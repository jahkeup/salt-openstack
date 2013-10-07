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
  - openstack.nova.mount

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

# Live Migration Settings

# nova-libvirt-conf-migration-tls-setting:
#   file.sed:
#     - name: /etc/libvirt/libvirtd.conf
#     - before: 0
#     - after: 1
#     - limit: ^listen_tls =
#     - require:
#       - file: nova-libvirt-conf-migration-tls-comment

# nova-libvirt-conf-migration-tls-comment:
#   file.uncomment:
#     - name: /etc/libvirt/libvirtd.conf
#     - regex: ^listen_tls = [01]$
#     - require:
#       - pkg: nova-compute-kvm

nova-libvirt-conf-migraiton-tcp-auth:
  file.append:
    - name: /etc/libvirt/libvirtd.conf
    - text: auth_tcp = "none"
    - require:
      - pkg: nova-compute-kvm


nova-libvirtbin-migration-opts:
  file.sed:
    - name: /etc/default/libvirt-bin
    - limit: ^libvirtd_opts=
    - before: '"-d"'
    - after: '"-d -l"'
    - require:
      - pkg: nova-compute-kvm

nova-libvirt-bin-service:
  service.running:
    - name: libvirt-bin
    - enable: True
    - require:
      - pkg: nova-compute-kvm
      - file: nova-libvirtbin-migration-opts
      - file: nova-libvirt-conf-migraiton-tcp-auth
      - file: nova-libvirt-conf-migration-tls-setting
    - watch:
      - file: nova-libvirtbin-migration-opts
      - file: nova-libvirt-conf-migraiton-tcp-auth
      - file: nova-libvirt-conf-migration-tls-setting