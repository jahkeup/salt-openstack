nova-user:
  group.present:
    - name: nova
    - gid: 221
  user.present:
    - name: nova
    - uid: 221
    - gid: 221