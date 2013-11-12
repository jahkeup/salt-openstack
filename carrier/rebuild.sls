{% include 'openstack/carrier/build.sls' with context %}

extend:
  controller-container:
    cmd.run:
      - unless: false
  {% for build in builds %}
  {{build}}-controller-container:
    cmd.run:
      - unless: false
  {% endfor %}
  
