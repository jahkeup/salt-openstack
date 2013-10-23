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

iptables-v4-rules:
  file.managed:
    - name: /etc/iptables/rules.v4
    - replace: True
    - source: salt://openstack/carrier/conf/rules
    - template: jinja
    - defaults:
        ip: 4
    - mode: 444
    - require:
      - pkg: iptables-persistent
    - require_in:
      - service: iptables-persistent
    - watch_in:
      - service: iptables-persistent

iptables-v6-rules:
  file.managed:
    - name: /etc/iptables/rules.v6
    - replace: True
    - source: salt://openstack/carrier/conf/rules
    - template: jinja
    - defaults:
        ip: 6
    - mode: 444
    - require:
      - pkg: iptables-persistent
    - require_in:
      - service: iptables-persistent
    - watch_in:
      - service: iptables-persistent