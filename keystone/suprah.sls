keystone-module-file:
  file.managed:
    - name: '/usr/lib/python2.7/dist-packages/salt/modules/keystone.py'
    - source: https://raw.github.com/jahkeup/salt/64740ea176be5d5226eec71422f94bdfcb3e95ea/salt/modules/keystone.py
    - source_hash: md5=2999c52563448bfeee82153df8abbf3f
    - backup: .orig

keystone-state-file:
  file.managed:
    - name: '/usr/lib/python2.7/dist-packages/salt/states/keystone.py'
    - source: https://raw.github.com/jahkeup/salt/keystone-connectionargs/salt/states/keystone.py
    - source_hash: md5=0dc68bf8fb294e56dc18aab9b764460d
    - backup: .orig
  