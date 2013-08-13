'/root/openstack_utils.tar.gz':
  file.managed:
    - source: salt://openstack/utils/utils.tar.gz
  archive.tar:
    - options: zxf
    - require:
        - file: '/root/openstack_utils.tar.gz'
