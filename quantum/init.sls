include:
  - openstack.repo
  - openstack.quantum.user
  - openstack.quantum.ovs
  - openstack.patch.kombu

quantum-server:
  pkg.installed:
    - pkgs: 
      - quantum-server
      - python-quantumclient
      - python-quantum
    - require:
      - user: quantum-user
      - file: /etc/quantum/quantum.conf
      - sls: openstack.patch.kombu
  service.running:
    - enable: True
    - require:
      - file: '/etc/quantum/quantum.conf'
    - watch:
      - file: '/etc/quantum/quantum.conf'

quantum-metadata-agent:
  pkg:
    - installed
  service.running:
    - enable: True
    - require:
      - pkg: quantum-metadata-agent
      - service: quantum-server
      - file: '/etc/quantum/metadata_agent.ini'
    - watch:
      - file: '/etc/quantum/quantum.conf'
      - file: '/etc/quantum/metadata_agent.ini'

quantum-dhcp-agent:
  pkg.installed:
    - require:
      - user: quantum
      - pkg: quantum-server
      - file: '/etc/quantum/dhcp_agent.ini'
      - file: '/etc/quantum/dnsmasq.conf'
  service.running:
    - enable: True
    - require:
      - pkg: quantum-dhcp-agent
      - file: '/etc/quantum/dnsmasq.conf'
      - file: '/etc/quantum/dhcp_agent.ini'
    - watch:
      - file: '/etc/quantum/dnsmasq.conf'
      - file: '/etc/quantum/dhcp_agent.ini'

quantum-l3-agent:
  pkg.installed:
    - require:
      - file: '/etc/quantum/l3_agent.ini'
      - user: quantum-user
  service.running:
    - enable: True
    - require:
      - file: '/etc/quantum/l3_agent.ini'
    - watch:
      - file: '/etc/quantum/l3_agent.ini'
      - file: '/etc/quantum/quantum.conf'

