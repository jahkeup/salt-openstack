ceph-repo:
  pkgrepo.managed:
    - name: deb http://ceph.com/debian-dumpling/ {{grains['oscodename']}} main
    - file: /etc/apt/sources.list.d/ceph.list
    - key_url: https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc
