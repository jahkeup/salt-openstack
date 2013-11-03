neutron-user:
  group.present:
    - name: neutron
    - gid: 222
  user.present:
    - name: neutron
    - uid: 222
    - gid: 222
    - home: /var/lib/neutron
    - require:
      - group: neutron