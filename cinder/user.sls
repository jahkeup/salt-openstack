cinder-user:
  group.present:
    - name: cinder
    - gid: 223
  user.present:
    - name: cinder
    - uid: 223
    - gid: 223
    - home: /var/lib/cinder
    - require:
        - group: cinder