# Compute Logstash shipper for nova-compute and quantum-*-agents
{% set role = "shipper" %}

{% include 'logstash/service.jinja' %}

extend:
  logstash-{{role}}-config:
    file.managed:
      - source: salt://openstack/logstash/conf/openstack-shipper.conf