{% set openstack = pillar['openstack'] -%}
{% set quantum = openstack['quantum'] -%}

include:
  - openstack.repo
  - openstack.quantum.user
  - openstack.quantum.conf
  - kernel.headers

quantum-plugin-openvswitch:
  pkg.installed:
    - pkgs:
      - openvswitch-switch
      - openvswitch-datapath-dkms
      - quantum-plugin-openvswitch
      - quantum-plugin-openvswitch-agent
    - require: 
      - file: '/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini'
      - user: quantum-user
  service.running:
    - name: quantum-plugin-openvswitch-agent
    - enable: True
    - require:
      - pkg: quantum-plugin-openvswitch

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

