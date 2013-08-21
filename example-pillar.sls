openstack:
  logging:
    debug: True
    verbose: True
  db:
    server: 69.43.73.66
    proto: mysql
    port: 3306
  auth:
    server: 69.43.73.66
    proto: http
    port: 35357
    service: service            # the service_tenant to auth as
  rabbit:
    server: 69.43.73.66
    username: guest
    password: rabbitpassword
  nova:
    metadata:
      server: 69.43.73.66
      secret: proxy-shared-secret
    compute:
      resume_guests: True
    db:
      name: nova
      username: nova
      password: novadbpassword
    service:
      username: nova
      password: novapassword
  keystone:
    endpoints:
      - 69.43.73.66
    db:
      name: keystone
      username: keystone
      password: keystonedbpass
    service:
      username: keystone
      password: keystonepass
  quantum:
    server:
      server: 69.43.73.66
      proto: http
      port: 9696
    network:
      type: vlan
      bridge_name: br-osgn
      vlan_range: 550:610
    db:
      name: quantum
      username: quantum
      password: quantumdbpass
    service:
      username: quantum
      password: quantumpass
  cinder:
    db:
      name: cinder
      username: cinder
      password: cinderdbpass
    service:
      username: cinder
      password: cinderpass
  glance:
    api:
      server: 69.43.73.66
      port:  9292
    db:
      name: glance
      username: glance
      password: glancedbpass
    service:
      username: glance
      password: glancepass
  ceph:
    conf: /etc/ceph/ceph.conf
    mon: 69.43.73.131
    glance:
      pool: images
      user: images
      uuid: 1000-0023-2323-2323
      key: >-
        RSA-KEY asdflkjsaflkasdflasdlfkasjdkdksdfd
        aksdlfjasldkfjasdflkjsljfksjdfjskdfsdfsdfd
        asdfasdfasdfasdfasdfasdfsdfsddsdfsdfsdfsds
      
    nova:
      path: /nova
      pool: instances
      user: instances
      uuid: 1100-1000-1020-1201
      key: >-
        RSA-KEY asdfasdfhajksdhflkasdjkflahskjashdf
        akjshdfkjahsdkflhljasdhfkhasjldkfhlasdjkfhd
        kajshdfkjlhasldfhlkasdhfshdkfksdhfkhksdhfjk