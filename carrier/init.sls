include:
  - docker

ufw:
  pkg.purged:
    - require:
      - pkg: docker

iptables-persistent:
  pkg.installed:
    - require:
      - pkg: ufw
  service.running:
    - enable: True
    - require:
      - file: iptables-rules
    - watch:
      - file: iptables-rules

iptables-rules:
  file.managed:
    - name: /etc/iptables/rules.v4
    - replace: True
    - source: salt://openstack/carrier/conf/rules
    - template: jinja
    - mode: 544
    - require:
      - pkg: iptables-persistent

