{% set openstack = pillar['openstack'] -%}
{% set keystone = openstack['keystone'] -%}
{% set conn = openstack['db']['connection'].items() -%}

keystone-database:
  mysql_database.present:
    - name: {{ keystone['db']['name'] }}
    {% for p,v in conn %}
    - connection_{{p}}: {{v}}
    {% endfor %}
  
keystone-database-user:
  mysql_user.present:
    - name: {{keystone['db']['username']}}
    - password: {{keystone['db']['password']}}
    - host: '%'
    {% for p,v in conn %}
    - connection_{{p}}: {{v}}
    {% endfor %}
    
keystone-database-localhost-user:
  mysql_user.present:
    - name: {{keystone['db']['username']}}
    - password: {{keystone['db']['username']}}
    - host: localhost
    {% for p,v in conn %}
    - connection_{{p}}: {{v}}
    {% endfor %}
    - watch:
        - mysql_user: keystone-database-user

keystone-database-grant:
  mysql_grants.present:
    - grant: all privileges
    - database: {{keystone['db']['name']}}.*
    - user: {{keystone['db']['username']}}
    - host: '%'
    {% for p,v in conn %}
    - connection_{{p}}: {{v}}
    {% endfor %}
    - require:
        - mysql_user: keystone-database-user
        - mysql_database: keystone-database

keystone-database-localhost-grant:
  mysql_grants.present:
    - grant: all privileges
    - database: {{keystone['db']['name']}}.*
    - host: localhost
    - user: {{keystone['db']['username']}}
    {% for p,v in conn %}
    - connection_{{p}}: {{v}}
    {% endfor %}
    - require:
        - mysql_user: keystone-database-localhost-user
        - mysql_database: keystone-database
    - watch:
        - mysql_grants: keystone-database-grant