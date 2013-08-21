{% set openstack = pillar['openstack'] %}
{% set ceph = openstack['ceph'] %}

include:
  - ceph.client
  - openstack.ceph.keys

# set_fstab(name, device, fstype, opts='defaults', dump=0, pass_num=0,
# config='/etc/fstab')
ceph-nova-mount:
  mount.set_fstab:
    - name: /var/lib/nova/instances
    - device: {{ ceph['mon'] }}:{{ ceph['nova']['path'] }}
    - fstype: ceph
    - opts: name=instances,secretfile=/etc/ceph/client.{{ ceph['nova']['user'] }}.secret,noauto
    - require: 
        - file: ceph-{{ ceph['nova']['user'] }}-key
