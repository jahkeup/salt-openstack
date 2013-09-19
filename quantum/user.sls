quantum-user:
  group.present:
    - name: quantum
    - gid: 222
  user.present:
    - name: quantum
    - uid: 222
    - gid: 222
    - home: /var/lib/quantum
    - require:
      - group: quantum