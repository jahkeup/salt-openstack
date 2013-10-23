include:
  - openstack.neutron.user

/etc/neutron:
  file.directory:
    - user: neutron
    - group: neutron
    - mode: 775
    - require:
      - user: neutron-user

/etc/neutron/plugins:
  file.directory:
    - user: neutron
    - group: neutron
    - mode: 775
    - require:
      - file: /etc/neutron

/etc/neutron/plugins/openvswitch:
  file.directory:
    - user: neutron
    - group: neutron
    - mode: 775
    - require:
      - file: /etc/neutron/plugins

/etc/neutron/neutron.conf:
  file.managed:
    - source: salt://openstack/neutron/conf/neutron.conf
    - template: jinja
    - user: neutron
    - group: neutron
    - mode: 440
    - require:
      - file: /etc/neutron

'/etc/neutron/dnsmasq.conf':
  file.managed:
    - source: salt://openstack/neutron/conf/dnsmasq.conf
    - template: jinja
    - user: neutron
    - group: neutron
    - mode: 440
    - require:
      - file: /etc/neutron

'/etc/neutron/metadata_agent.ini':
  file.managed:
    - source: salt://openstack/neutron/conf/metadata_agent.ini
    - template: jinja
    - user: neutron
    - group: neutron
    - mode: 440
    - require:
      - file: /etc/neutron

'/etc/neutron/dhcp_agent.ini':
  file.managed:
    - source: salt://openstack/neutron/conf/dhcp_agent.ini
    - user: neutron
    - group: neutron
    - template: jinja
    - mode: 440
    - require:
      - file: /etc/neutron

'/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini':
  file.managed:
    - source: salt://openstack/neutron/conf/plugin.ini
    - user: neutron
    - group: neutron
    - mode: 440
    - template: jinja
    - require:
      - file: '/etc/neutron/plugins/openvswitch'

'/etc/neutron/plugin.ini':
  file.symlink:
    - user: neutron
    - group: neutron
    - mode: 440
    - target: '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini'
    - require:
      - file: '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini'


'/etc/neutron/lbaas_agent.ini':
  file.managed:
    - source: salt://openstack/neutron/lbass_agent.ini
    - user: neutron
    - group: neutron
    - mode: 440
    - template: jinja
    - require:
      - file: '/etc/neutron'