{% set openstack = pillar['openstack'] -%}
{% set quantum = openstack['quantum'] -%}

include:
  - openstack.repo
  - openstack.quantum.user

quantum-plugin-openvswitch:
  pkg.installed:
    - require: 
        - user: quantum

quantum-plugin-openvswitch-agent:
  pkg.installed:
    - require: 
        - user: quantum

  service.running:
    - enable: True
    - require:
        - pkg: quantum-plugin-openvswitch-agent
include:
  - kernel.headers

openvswitch-switch:
  pkg.installed:
    - pkgs:
        - openvswitch-switch
        - openvswitch-datapath-source

openvswitch-datapath-module:
  pkg.installed:
    - name: openvswitch-datapath-module-{{ grains['kernelrelease'] }}
    - require:
        - pkg: openvswitch-switch

openvswitch-service:
  service.running:
    - name: openvswitch-switch
    - enable: True
    - require:
        - pkg: openvswitch-datapath-module

manual-compiled-ovs:
  cmd.wait:
    - name: |
        module-assistant auto-install openvswitch-datapath
    - require:
        - pkg: kernel.headers
    - watch:
        - pkg: openvswitch-switch

{{ quantum['network'].get('integration_bridge','br-int') }}:
  ovs.bridged:
    - require:
        - pkg: openvswitch-switch
{{ quantum['network']['bridge_name'] }}:
  ovs.bridged:
    - ports:
      {% for port in grains['openstack']['network']['ports'] %}
      - {{ port }}
      {% endfor %}
    - require:
        - pkg: openvswitch-switch

/etc/quantum/plugins/openvswitch:
  file.directory:
    - user: quantum
    - group: quantum
    - require:
      - user: quantum
      - pkg: quantum-plugin-openvswitch

'/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini':
  file.managed:
    - source: salt://openstack/quantum/conf/plugin.ini
    - user: quantum
    - group: quantum
    - template: jinja
    - require:
      - pkg: quantum-plugin-openvswitch
      - user: quantum
      - file.directory: /etc/quantum/plugins/openvswitch

'/etc/quantum/plugin.ini':
  file.symlink:
    - target: '/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini'
    - require:
      - file: '/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini'
