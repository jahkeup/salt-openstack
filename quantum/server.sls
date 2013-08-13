include:
  - openstack.quantum.ovs

quantum-server:
  pkg:
    - installed
quantum-common:
  pkg:
    - installed

/etc/quantum:
  file.directory:
    - user: quantum
    - group: quantum
    - require:
        - pkg: quantum-server
{% for conf in 'api-paste.ini','dhcp_agent.ini','dnsmasq.conf','l3_agent.ini','metadata_agent.ini','quantum.conf' %}
/etc/quantum/{{conf}}:
  file.managed:
    - source: salt://openstack/quantum/conf/{{conf}}
    - template: jinja
    - user: quantum
    - group: quantum
    - require:
      - file.directory: /etc/quantum
{% endfor %}
