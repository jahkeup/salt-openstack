include:
  - carrier
{% for service in ['nova','glance','neutron','keystone','cinder', 'rabbit'] %}
  - openstack.{{service}}.carrier.shipment
{% endfor %}
