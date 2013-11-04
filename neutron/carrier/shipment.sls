{% set staging = "/srv/container/neutron/conf" %}
include:
  - openstack.neutron.user
  - openstack.neutron.conf

extend:
  /etc/neutron:
    file.directory:
      - name: {{staging}}

  /etc/neutron/plugins:
    file.directory:
      - name: {{staging}}/plugins

  /etc/neutron/plugins/openvswitch:
    file.directory:
      - name: {{staging}}/openvswitch

  /etc/neutron/neutron.conf:
    file.managed:
      - name: {{staging}}/neutron.conf

  '/etc/neutron/dnsmasq.conf':
    file.managed:
      - name: {{staging}}/dnsmasq.conf

  '/etc/neutron/metadata_agent.ini':
    file.managed:
      - name: {{staging}}/metadata_agent.ini

  '/etc/neutron/dhcp_agent.ini':
    file.managed:
      - name: {{staging}}/dhcp_agent.ini

  '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini':
    file.managed:
      - name: {{staging}}/plugins/openvswitch/ovs_neutron_plugin.ini

  '/etc/neutron/plugin.ini':
    file.symlink:
      - name: {{staging}}/plugin.ini
      - target: '{{staging}}/plugins/openvswitch/ovs_neutron_plugin.ini'

  '/etc/neutron/lbaas_agent.ini':
    file.managed:
      - name: {{staging}}/lbaas_agent.ini
