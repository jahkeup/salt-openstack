keystone-module-file:
  file.managed:
    - name: '/usr/lib/python2.7/dist-packages/salt/modules/keystone.py'
    # - source: https://raw.github.com/jahkeup/salt/keystone-connectionargs/salt/modules/keystone.py 
    # - source_hash: md5=2999c52563448bfeee82153df8abbf3f
    - source: salt://openstack/keystone/suprah/files/keystone-module.py
    - backup: .orig

keystone-state-file:
  file.managed:
    - name: '/usr/lib/python2.7/dist-packages/salt/states/keystone.py'
    # - source: https://raw.github.com/jahkeup/salt/keystone-connectionargs/salt/states/keystone.py
    # - source_hash: md5=0dc68bf8fb294e56dc18aab9b764460d
    - source: salt://openstack/keystone/suprah/file/keystone-state.py
    - backup: .orig
  