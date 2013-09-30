include:
  - openstack.quantum.user

/etc/quantum:
  file.directory:
    - user: quantum
    - group: quantum
    - mode: 775
    - require:
      - user: quantum-user

/etc/quantum/plugins:
  file.directory:
    - user: quantum
    - group: quantum
    - mode: 775
    - require:
      - file: /etc/quantum

/etc/quantum/plugins/openvswitch:
  file.directory:
    - user: quantum
    - group: quantum
    - mode: 775
    - require:
      - file: /etc/quantum/plugins

/etc/quantum/quantum.conf:
  file.managed:
    - source: salt://openstack/quantum/conf/quantum.conf
    - template: jinja
    - user: quantum
    - group: quantum
    - mode: 440
    - require:
      - file: /etc/quantum

'/etc/quantum/dnsmasq.conf':
  file.managed:
    - source: salt://openstack/quantum/conf/dnsmasq.conf
    - template: jinja
    - user: quantum
    - group: quantum
    - mode: 440
    - require:
      - file: /etc/quantum

'/etc/quantum/metadata_agent.ini':
  file.managed:
    - source: salt://openstack/quantum/conf/metadata_agent.ini
    - template: jinja
    - user: quantum
    - group: quantum
    - mode: 440
    - require:
      - file: /etc/quantum

'/etc/quantum/dhcp_agent.ini':
  file.managed:
    - source: salt://openstack/quantum/conf/dhcp_agent.ini
    - user: quantum
    - group: quantum
    - template: jinja
    - mode: 440
    - require:
      - file: /etc/quantum
'/etc/quantum/l3_agent.ini':
  file.managed:
    - source: salt://openstack/quantum/conf/dhcp_agent.ini
    - template: jinja
    - user: quantum
    - group: quantum
    - mode: 440
    - require:
      - file: /etc/quantum

'/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini':
  file.managed:
    - source: salt://openstack/quantum/conf/plugin.ini
    - user: quantum
    - group: quantum
    - mode: 440
    - template: jinja
    - require:
      - file: '/etc/quantum/plugins/openvswitch'

'/etc/quantum/plugin.ini':
  file.symlink:
    - user: quantum
    - group: quantum
    - mode: 440
    - target: '/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini'
    - require:
      - file: '/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini'


