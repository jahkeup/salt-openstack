{% set staging = "/srv/container" %}
include:
  - openstack.neutron.user
  - openstack.neutron.conf

extend:
  /etc/neutron:
    file.directory:
      - name: {{staging}}/neutron

  /etc/neutron/plugins:
    file.directory:
      - name: {{staging}}/neutron/plugins

  /etc/neutron/plugins/openvswitch:
    file.directory:
      - name: {{staging}}/neutron/openvswitch

  /etc/neutron/neutron.conf:
    file.managed:
      - name: {{staging}}/neutron/neutron.conf

  '/etc/neutron/dnsmasq.conf':
    file.managed:
      - name: {{staging}}/neutron/dnsmasq.conf

  '/etc/neutron/metadata_agent.ini':
    file.managed:
      - name: {{staging}}/neutron/metadata_agent.ini

  '/etc/neutron/dhcp_agent.ini':
    file.managed:
      - name: {{staging}}/neutron/dhcp_agent.ini

  '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini':
    file.managed:
      - name: {{staging}}/neutron/plugins/openvswitch/ovs_neutron_plugin.ini

  '/etc/neutron/plugin.ini':
    file.symlink:
      - name: {{staging}}/neutron/plugin.ini
      - target: '{{staging}}/neutron/plugins/openvswitch/ovs_neutron_plugin.ini'

  '/etc/neutron/lbaas_agent.ini':
    file.managed:
      - name: {{staging}}/neutron/lbaas_agent.ini
