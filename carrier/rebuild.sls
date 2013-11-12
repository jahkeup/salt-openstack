{% from 'openstack/carrier/build.sls' import builds %}

include:
  - openstack.carrier.build

extend:
  controller-container:
    cmd.run:
      - unless: false
  {% for build in builds %}
  {{build}}-controller-container:
    cmd.run:
      - unless: false
  {% endfor %}
  
