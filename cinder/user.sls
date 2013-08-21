cinder:
  group.present:
    - gid: 223
  user.present:
    - uid: 223
    - gid: 223
    - home: /var/lib/cinder
    - require:
        - group: cinder