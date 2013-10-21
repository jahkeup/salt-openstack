nova-user:
  group.present:
    - name: nova
    - gid: 221
  user.present:
    - name: nova
    - uid: 221
    - gid: 221
    - remove_groups: False
    - groups:
        - libvirtd
    - require:
      - group: nova-user
      - user: libvirt-user

libvirt-user:
  group.present:
    - name: libvirtd
    - gid: 225
  user.present:
    - name: libvirt-qemu
    - uid: 225
    - gid: 225
    - require:
      - group: libvirt-user
      - group: kvm-group

kvm-group:
  group.present:
    - name: kvm
    - gid: 226

