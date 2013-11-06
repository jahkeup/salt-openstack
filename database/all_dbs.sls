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

{{service}}-database-localhost-user:
  mysql_user.present:
    - name: {{openstack[service]['db']['username']}}
    - password: {{openstack[service]['db']['username']}}
    - host: localhost
    {% for p,v in conn %}
    - connection_{{p}}: {{v}}
    {% endfor %}
    - watch:
        - mysql_user: {{service}}-database-user

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

{{service}}-database-localhost-grant:
  mysql_grants.present:
    - grant: all privileges
    - database: {{openstack[service]['db']['name']}}.*
    - host: localhost
    - user: {{openstack[service]['db']['username']}}
    {% for p,v in conn %}
    - connection_{{p}}: {{v}}
    {% endfor %}
    - require:
        - mysql_user: {{service}}-database-localhost-user
        - mysql_database: {{service}}-database
    - watch:
        - mysql_grants: {{service}}-database-grant


{% endfor %}

