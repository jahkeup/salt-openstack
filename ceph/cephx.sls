ceph:
  service.running:
    - enable: True

volumes-user: 
  file.managed:
    - name: /etc/ceph/ceph.client.volumes.keyring
    - mode: 440
    - require:
      - cmd: volumes-user
  cmd.run: 
    - name: >- 
        ceph auth get-or-create client.volumes
        mon 'allow r'
        mds 'allow'
        osd 'allow class-read object_prefix rbd_children,
        allow rwx pool=volumes,
        allow rx pool=images' > /etc/ceph/ceph.client.volumes.keyring


images-user:
  file.managed:
    - name: /etc/ceph/ceph.client.images.keyring
    - mode: 440
    - require:
      - cmd: images-user
  cmd.run: 
    - name: >- 
        ceph auth get-or-create client.images
        mon 'allow r'
        mds 'allow'
        osd 'allow class-read object_prefix rbd_children,
        allow rwx pool=images' > /etc/ceph/ceph.client.images.keyring


instances-user:
  file.managed:
    - name: /etc/ceph/ceph.client.instances.keyring
    - mode: 440
    - require:
      - cmd: instances-user
  cmd.run: 
    - name: >- 
        ceph auth get-or-create client.images
        mon 'allow r'
        mds 'allow'
        osd 'allow class-read object_prefix rbd_children,
        allow rwx pool=instances' > /etc/ceph/ceph.client.instances.keyring
      