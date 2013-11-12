{% set build_base = '/srv/container' -%}
{% set builds = ['keystone', 'glance', 'rabbit'] -%}
{% set check_cmd = "docker images | egrep '^{0}\s'" -%}
include:
  - openstack.carrier

controller-container:
  cmd.run:
    - name: docker build -t controller .
    - cwd: {{build_base}}
    - unless: {{check_cmd.format('controller')}}
    - require:
      - git: carrier-container-repo # must exist, will fail if missing pillar data.

{% for build in builds %}
{{build}}-controller-container:
  cmd.run:
    - name: docker build -t controller/{{build}} .
    - cwd: {{build_base}}/{{build}}
    - unless: {{check_cmd.format('controller/' + build)}}
    - require:
      - cmd: controller-container
{{build}}-controller-upstart-service:
  cmd.run:
    - name: cp {{build_base}}/{{build}}/{{build}}-upstart.conf /etc/init/{{build}}-container.conf
    - unless: diff /etc/init/{{build}}-container.conf {{build_base}}/{{build}}/{{build}}-container.conf
    - require:
      - cmd: {{build}}-controller-container

{{build}}-controller-init-service:
  file.symlink:
    - name: /etc/init.d/{{build}}-container
    - target: /lib/init/upstart-job
    - require:
      - cmd: {{build}}-controller-upstart-service
{% endfor %}

