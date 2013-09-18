openstack:
  logging:
    debug: True
    verbose: True
  db:
    server: 33.33.33.10
    proto: mysql
    port: 3306
    connection:
      host: 33.33.33.10
      user: root
      pass: password
      port: 3306
  auth:
    server: 69.43.73.66
    proto: http
    port: 35357
    service: service            # the service_tenant to auth as
    connection:                 # Connection must be made by an admin
      user: admin               # tenant user. This is typically the 
      password: password        # same user as you create with keystone
      insecure: True            # insecure: for non-ssl
    backend:
      server: 69.43.73.66
      proto: http
      port: 5000
  keystone:
    endpoints:
      - 69.43.73.66
    db:
      name: keystone
      username: keystone
      password: keystonedbpass
    service:                    # This is the default admin account
      username: admin
      password: adminpassword
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
  quantum:
    server:
      server: 69.43.73.66
      proto: http
      port: 9696
    network:
      domain: cld.example.net
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