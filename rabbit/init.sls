{% set openstack = pillar['openstack'] -%}
{% set rabbit = openstack['rabbit'] -%}

rabbitmq-server:
  pkg:
    - installed
  service.running:
    - enable: True
    - require:
      - pkg: rabbitmq-server
      - cmd: rabbitmq-server
  cmd.wait:
    - name: rabbitmqctl change_password guest {{rabbit['password']}}
    - require:
      - pkg: rabbitmq-server
    - watch:
      - pkg: rabbitmq-server