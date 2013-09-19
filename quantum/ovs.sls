{% set openstack = pillar['openstack'] -%}
{% set quantum = openstack['quantum'] -%}

include:
  - openstack.repo
  - openstack.quantum.user
  - kernel.headers

quantum-plugin-openvswitch:
  pkg.installed:
    - require: 
        - user: quantum-user

quantum-plugin-openvswitch-agent:
  pkg.installed:
    - require: 
        - user: quantum-user

  service.running:
    - enable: True
    - require:
        - pkg: quantum-plugin-openvswitch-agent

openvswitch-switch:
  pkg.installed:
    - pkgs:
        - openvswitch-switch
        - openvswitch-datapath-dkms

openvswitch-service:
  service.running:
    - name: openvswitch-switch
    - enable: True
    - require:
        - pkg: openvswitch-switch

{{ quantum['network'].get('integration_bridge','br-int') }}:
  ovs.bridged:
    - require:
      - service: openvswitch-service

{{ quantum['network']['bridge_name'] }}:
  ovs.bridged:
    - ports:
      {% for port in grains['openstack']['network']['ports'] %}
      - {{ port }}
      {% endfor %}
    - require:
      - service: openvswitch-switch

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
