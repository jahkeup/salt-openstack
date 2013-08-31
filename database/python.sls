{% set db = pillar['openstack']['db'] -%}
{% if db['proto'] == 'mysql' %}
openstack-database-python:
  pkg.installed:
    - name: python-mysqldb
{% endif %}
