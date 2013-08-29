include:
  - openstack.database.repo
  - openstack.database.python

{% set openstack = pillar['openstack'] -%}
{% set db = openstack['db'] -%}

{% if db['proto'] == 'mysql' %}
{% set db_module = 'mysql' -%}
openstack-database-server:
  pkg.installed:
    - name: mysql-server
  service.running:
    - name: mysql
    - require:
        - pkg: openstack-database-server
        - sls: openstack.dataabase.repo

{% elif db['proto'] == 'postgresql' %}
{% set db_module = 'postgres' -%}
openstack-database-server:
  pkg.installed:
    - name: postgresql-9.1
  service.running:
    - name: postgresql
    - require:
        - pkg: openstack-database-server
        - sls: openstack-database-repo

{% endif %}

{# {% for database in ['keystone','nova','quantum','cinder','glance'] %} #}
{# openstack-{{ database }}-database: #}
  
{# {% endfor %} #}


