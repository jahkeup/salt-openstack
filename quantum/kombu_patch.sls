'/usr/lib/python2.7/dist-packages/kombu/serialization.py':
  file.patch:
    - source: salt://openstack/quantum/patch/kombu_serialization.patch
    - hash: md5=efc82073dc073e464f3c115e24eaea4c
    - require:
      - pkg: patch
patch:
  pkg.installed