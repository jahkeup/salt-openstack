keystone:
  group.present:
    - gid: 220

  user.present: 
    - uid: 220
    - gid: 220
    - home: /var/lib/keystone
