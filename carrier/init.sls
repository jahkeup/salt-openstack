# Host also need a loopback on 192.0.2.1
# auto lo lo:1
# iface lo:1 inet static
#   address 192.0.2.1/32
#

include:
  - docker
  - git

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

dnsmasq:
  pkg.installed:
    - require:
      - service: iptables-persistent
  service.running:
    - require:
      - file: dnsmasq
    - watch:
      - file: dnsmasq
  file.managed:
    - name: /etc/dnsmasq.d/hosts
    - contents: |
        addn-hosts=/etc/hosts

{% if '192.0.2.1' in grains['ipv4'] %}
docker-dnsmasq-conf:
  file.sed:
    - name: /etc/dnsmasq.conf
    - before: '^#listen-address='
    - after: 'listen-address=192.0.2.1,127.0.0.1'
    - require_in:
      - service: dnsmasq
    - watch_in:
      - service: dnsmasq
docker-dns-service:
  file.sed:
    - name: /etc/init/docker.conf
    - before: '/usr/bin/docker -d$'
    - after: '/usr/bin/docker -d -dns 192.0.2.1'
    - require_in:
      - service: docker
    - watch_in:
      - service: docker
{% endif %}

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

{% if salt['pillar.get']('openstack:carrier:repo') %}
carrier-container-repo:
  git.latest:
    - name: {{salt['pillar.get']('openstack:carrier:repo') }}
    - target: /srv/container
    - identity: /srv/git_user.key
    - force_checkout: True      # There will be the conf/ from shipments
    - require:
      - file: git-key
    - require_in:
      - file: carrier-config-dir

carrier-ssh-into:
  cmd.run:
    - name: cp /srv/container/shared/ssh_into /usr/bin/ssh_into
    - unless: diff /srv/container/shared/ssh_into /usr/bin/ssh_into
    - require:
      - git: carrier-container-repo

{% endif %}

