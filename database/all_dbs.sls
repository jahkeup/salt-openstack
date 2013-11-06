{% set openstack = pillar['openstack'] -%}
{% set conn = openstack['db']['connection'].items() -%}

{% for service in ['keystone','nova','neutron','glance','cinder'] %}

{{service}}-database:
  mysql_database.present:
    - name: {{ openstack[service]['db']['name'] }}
    {% for p,v in conn %}
    - connection_{{p}}: {{v}}
    {% endfor %}

{{service}}-database-user:
  mysql_user.present:
    - name: {{openstack[service]['db']['username']}}
    - password: {{openstack[service]['db']['password']}}
    - host: '%'
    {% for p,v in conn %}
    - connection_{{p}}: {{v}}
    {% endfor %}

{{service}}-database-grant:
  mysql_grants.present:
    - grant: all privileges
    - database: {{openstack[service]['db']['name']}}.*
    - user: {{openstack[service]['db']['username']}}
    - host: '%'
    {% for p,v in conn %}
    - connection_{{p}}: {{v}}
    {% endfor %}
    - require:
        - mysql_user: {{service}}-database-user
        - mysql_database: {{service}}-database
{% endfor %}

