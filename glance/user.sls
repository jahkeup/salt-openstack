glance-user:
  group.present:
    - name: glance
    - gid: 224
  user.present:
    - name: glance
    - uid: 224
    - gid: 224
    - require:
        - group: glance
        