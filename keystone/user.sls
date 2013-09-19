keystone-user:
  group.present:
    - name: keystone
    - gid: 220
  user.present: 
    - name: keystone
    - uid: 220
    - gid: 220
    - home: /var/lib/keystone
    - require:
        - group: keystone
