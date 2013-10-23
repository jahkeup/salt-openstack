# Compute Logstash shipper for *-api + services
{% set role = "shipper" %}

{% include 'logstash/service.jinja' %}

extend:
  logstash-{{role}}-config:
    file.managed:
      - source: salt://openstack/logstash/conf/openstack-shipper.conf
      - replace: True
