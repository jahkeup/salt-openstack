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

'/etc/quantum/quantum.conf':
  file.managed:
    - source: salt://openstack/quantum/conf/quantum.conf
    - template: jinja
    - require:
        - pkg: quantum-server

quantum-dhcp-agent:
  pkg.installed:
    - require:
        - user: quantum

'/etc/quantum/dhcp_agent.ini':
  file.managed:
    - source: salt://openstack/quantum/conf/dhcp_agent.ini
    - template: jinja
    - require:
        - pkg: quantum-dhcp-agent

quantum-l3-agent:
  pkg.installed:
    - require:
        - user: quantum

'/etc/quantum/l3_agent.ini':
  file.managed:
    - source: salt://openstack/quantum/conf/l3_agent.ini
    - template: jinja
    - require:
        - pkg: quantum-l3-agent

