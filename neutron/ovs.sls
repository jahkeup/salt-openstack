{% set openstack = pillar['openstack'] -%}
{% set neutron = openstack['neutron'] -%}

include:
  - openstack.neutron.user
  - openstack.neutron.conf
  - kernel.headers

neutron-plugin-openvswitch:
  pkg.installed:
    - pkgs:
      - openvswitch-switch
      - openvswitch-datapath-dkms
      - neutron-plugin-openvswitch
      - neutron-plugin-openvswitch-agent
    - require:
      - file: '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini'
      - user: neutron-user
  service.running:
    - name: neutron-plugin-openvswitch-agent
    - enable: True
    - watch:
      - file: '/etc/neutron/neutron.conf'
      - file: '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini'
    - require:
      - pkg: neutron-plugin-openvswitch

openvswitch-service:
  service.running:
    - name: openvswitch-switch
    - enable: True
    - require:
      - pkg: neutron-plugin-openvswitch

{{ neutron['network'].get('integration_bridge','br-int') }}:
  ovs.bridged:
    - require:
      - service: openvswitch-service

{{ neutron['network']['bridge_name'] }}:
  ovs.bridged:
    - ports:
      {% for port in grains['openstack']['network']['ports'] %}
      - {{ port }}
      {% endfor %}
    - require:
      - service: openvswitch-service

