include:
  - openstack.neutron.user
  - openstack.neutron.ovs
  - openstack.patch.kombu

neutron-server:
  pkg.installed:
    - pkgs:
      - neutron-server
      - python-neutronclient
      - python-neutron
    - require:
      - user: neutron-user
      - file: /etc/neutron/neutron.conf
      - sls: openstack.patch.kombu
  service.running:
    - enable: True
    - require:
      - file: '/etc/neutron/neutron.conf'
    - watch:
      - file: '/etc/neutron/neutron.conf'

neutron-metadata-agent:
  pkg:
    - installed
  service.running:
    - enable: True
    - require:
      - pkg: neutron-metadata-agent
      - service: neutron-server
      - file: '/etc/neutron/metadata_agent.ini'
    - watch:
      - file: '/etc/neutron/neutron.conf'
      - file: '/etc/neutron/metadata_agent.ini'

neutron-dhcp-agent:
  pkg.installed:
    - require:
      - user: neutron
      - pkg: neutron-server
      - file: '/etc/neutron/dhcp_agent.ini'
      - file: '/etc/neutron/dnsmasq.conf'
  service.running:
    - enable: True
    - require:
      - pkg: neutron-dhcp-agent
      - file: '/etc/neutron/dnsmasq.conf'
      - file: '/etc/neutron/dhcp_agent.ini'
    - watch:
      - file: '/etc/neutron/dnsmasq.conf'
      - file: '/etc/neutron/dhcp_agent.ini'

neutron-l3-agent:
  pkg.installed:
    - require:
      - file: '/etc/neutron/l3_agent.ini'
      - user: neutron-user
  service.running:
    - enable: True
    - require:
      - file: '/etc/neutron/l3_agent.ini'
    - watch:
      - file: '/etc/neutron/l3_agent.ini'
      - file: '/etc/neutron/neutron.conf'

