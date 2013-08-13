quantum-plugin-openvswitch:
  pkg:
    - installed

quantum-plugin-openvswitch-agent:
  pkg:
    - installed

/etc/quantum/plugins/openvswitch:
  file.directory:
    - user: quantum
    - group: quantum
    - require:
      - pkg: quantum-plugin-openvswitch

'/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini':
  file.managed:
    - source: salt://openstack/quantum/conf/plugin.ini
    - user: quantum
    - group: quantum
    - template: jinja
    - require:
      - pkg: quantum-plugin-openvswitch
      - file.directory: /etc/quantum/plugins/openvswitch
'/etc/quantum/plugin.ini':
  file.symlink:
    - target: '/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini'
    - require:
      - file: '/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini'