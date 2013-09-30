# Instances nfs backend mount
{% set openstack = pillar['openstack'] -%}
{% set nova = openstack['nova'] -%}
{% set ceph = openstack['ceph'] -%}

nova-instances-store:
  file.managed:
    - name: /etc/fstab.d/nfs-instances.fstab
    - contents: >-
        {{nova['instances_store']['server']}}:{{nova['instances_store']['path']}}
        /var/lib/nova/instances	nfs4	_netdev,tcp,noauto	0	0
