{% if db['proto'] == 'mysql' %}
openstack-database-python:
  - pkg.installed:
      - name: python-mysqldb
{% endif %}
