include:
  - openstack.quantum.user
  - openstack.quantum.ovs

quantum-server:
  pkg.installed:
    - pkgs: 
        - quantum-server
        - python-quantumclient
        - python-quantum
    - require:
        - user: quantum
  service.running:
    - enable: True
    - require:
      - file: '/etc/quantum/quantum.conf'
    - watch:
      - file: '/etc/quantum/quantum.conf'

'/etc/quantum/quantum.conf':
  file.managed:
    - source: salt://openstack/quantum/conf/quantum.conf
    - user: quantum
    - group: quantum
    - template: jinja
    - require:
        - pkg: quantum-server

quantum-metadata-agent:
  service.running:
    - enable: True
    - require:
      - file: '/etc/quantum/metadata_agent.ini'
    - watch:
      - file: '/etc/quantum/metadata_agent.ini'

'/etc/quantum/metadata_agent.ini':
  file.managed:
    - source: salt://openstack/quantum/conf/metadata_agent.ini
    - user: quantum
    - group: quantum
    - template: jinja
    - require:
      - pkg: quantum-server

quantum-dhcp-agent:
  pkg.installed:
    - require:
        - user: quantum
  service.running:
    - enable: True
    - require:
      - file: '/etc/quantum/dhcp_agent.ini'
    - watch:
      - file: '/etc/quantum/dhcp_agent.ini'

'/etc/quantum/dhcp_agent.ini':
  file.managed:
    - source: salt://openstack/quantum/conf/dhcp_agent.ini
    - user: quantum
    - group: quantum
    - template: jinja
    - require:
        - pkg: quantum-dhcp-agent

quantum-l3-agent:
  pkg.installed:
    - require:
      - user: quantum
  service.running:
    - enable: True
    - require:
      - file: '/etc/quantum/l3_agent.ini'
    - watch:
      - file: '/etc/quantum/l3_agent.ini'

'/etc/quantum/l3_agent.ini':
  file.managed:
    - source: salt://openstack/quantum/conf/l3_agent.ini
    - user: quantum
    - group: quantum
    - template: jinja
    - require:
        - pkg: quantum-l3-agent

