# Host also need a loopback on 192.0.2.1
# auto lo lo:1
# iface lo:1 inet static
#   address 192.0.2.1/32
#

include:
  - docker

ufw:
  pkg.purged:
    - require:
      - pkg: docker
dnsmasq:
  pkg.installed:
    - require:
      - service: iptables-persistent
  {% if '192.0.2.1' in grains['ipv4'] %}
  file.sed:
  - name: /etc/dnsmasq.conf
  - before: '^#listen-address='
  - after: listen-address=192.0.2.1
  - require_in:
    - service: dnsmasq
  - watch_in:
    - service: dnsmasq
  {% endif %}
  service.running: []

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

carrier-config-dir:
  file.directory:
    - name: /srv/container
    - mode: 775

carrier-config-dir-shorthand:
  file.symlink:
    - name: /srv/c
    - target: /srv/container
    - require:
      - file: carrier-config-dir

carrier-log-dir:
  file.directory:
    - name: /srv/container/log
    - mode: 777

carrier-log-dir-shorthand:
  file.symlink:
    - name: /srv/l
    - target: /srv/container/log
    - require:
      - file: carrier-log-dir