neutron-user:
  group.present:
    - name: neutron
    - gid: 226
  user.present:
    - name: neutron
    - uid: 226
    - gid: 226
    - home: /var/lib/neutron
    - require:
      - group: neutron