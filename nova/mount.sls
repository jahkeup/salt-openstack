# Instances nfs backend mount
{% set openstack = pillar['openstack'] -%}
{% set nova = openstack['nova'] -%}
{% set ceph = openstack['ceph'] -%}

nova-instances-store:
  file.managed:
    - name: /sbin/mount.instances
    - mode: 555
    - user: root
    - group: root
    - contents: |
        #!/usr/bin/env bash
        mount -t nfs4 -o tcp,noauto {{nova['instances_store']['server']}} \
          /var/lib/nova/instances
