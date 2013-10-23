# Compute Logstash shipper for nova-compute and neutron-*-agents
{% set role = "shipper" %}

{% include 'logstash/service.jinja' %}

extend:
  logstash-{{role}}-config:
    file.managed:
      - source: salt://openstack/logstash/conf/openstack-shipper.conf
