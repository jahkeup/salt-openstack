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
  memcached:
    - 127.0.0.1
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
    workers: 5
    instances_store:
      server: 10.0.0.2
      path: /export/instances
    novnc:
      server: 140.186.77.2
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
  neutron:
    server:
      server: network.api.cld.packetsurge.net
      proto: http
      port: 9696
    network:
      domain: cld.packetsurge.net
      type: vlan
      bridge_name: br-osgn
      vlan_range: 550:610
    db:
      name: neutron
      username: neutron
      password: neutrondbpass
    service:
      username: neutron
      password: neutronpass
  cinder:
    db:
      name: cinder
      username: cinder
      password: cinderdbpass
    service:
      username: cinder
      password: cinderpass
  glance:
    workers: 5
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
    cinder:
      pool: volumes
      user: volumes
      uuid: 1100-1000-1020-1201
      key: >-
        RSA-KEY asdfasdfhajksdhflkasdjkflahskjashdf
        akjshdfkjahsdkflhljasdhfkhasjldkfhlasdjkfhd
        kajshdfkjlhasldfhlkasdhfshdkfksdhfkhksdhfjk

    nova:
      path: /nova
      pool: instances
      user: instances
      uuid: 1100-1000-1020-1201
      key: >-
        RSA-KEY asdfasdfhajksdhflkasdjkflahskjashdf
        akjshdfkjahsdkflhljasdhfkhasjldkfhlasdjkfhd
        kajshdfkjlhasldfhlkasdhfshdkfksdhfkhksdhfjk
  endpoints:
    nova:
      public: http://162.219.98.18:8774/v2/$(tenant_id)s
      internal: http://140.186.77.2:8774/v2/$(tenant_id)s
      admin: http://140.186.77.2:8774/v2/$(tenant_id)s
    volume:
      public: http://162.219.98.18:8776/v1/$(tenant_id)s
      internal: http://140.186.77.2:8776/v1/$(tenant_id)s
      admin: http://140.186.77.2:8776/v1/$(tenant_id)s
    glance:
      public: http://162.219.98.18:9292/v2
      internal: http://140.186.77.2:9292/v2
      admin: http://140.186.77.2:9292/v2
    swift:
      public: http://162.219.98.18:8080/v1/AUTH_$(tenant_id)s
      internal: http://140.186.77.2:8080/v1/AUTH_$(tenant_id)s
      admin: http://140.186.77.2:8080/v1
    ec2:
      public: http://162.219.98.18:8773/services/Cloud
      internal: http://140.186.77.2:8773/services/Cloud
      admin: http://140.186.77.2:8773/services/Admin
    quantum:
      public: http://162.219.98.20:9696/
      internal: http://140.186.77.3:9696/
      admin: http://140.186.77.3:9696/
    keystone:
      public: http://162.219.98.18:5000/v2.0
      internal: http://140.186.77.2:5000/v2.0
      admin: http://140.186.77.2:35357/v2.0




