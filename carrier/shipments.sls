include:
  - carrier
{% for service in ['nova','glance','neutron','keystone','cinder'] %}
  - openstack.{{service}}.carrier.shipment
{% endfor %}
