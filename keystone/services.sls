{% set openstack = pillar['openstack'] -%}
{% set keystone = openstack['keystone'] -%}
{% set auth = openstack['auth'] -%}
{% set endpoint = auth.get('proto','http') + "://"+ auth['server']+":35357/v2.0/" -%}
{% set token = keystone['service']['password'] -%}


admin-role:
  keystone.role_present:
    - name: admin
    - connection_endpoint: {{endpoint}}
    - connection_token: {{token}}

service-tenant:
  keystone.tenant_present:
    - name: service
    - description: Service Tenant
    - connection_endpoint: {{endpoint}}
    - connection_token: {{token}}
    - users:
        {% for service_tenant in ['nova','quantum','cinder','glance'] %}
        {% set info = openstack[service_tenant]['service'] %}

        {{service_tenant}}:
          - name: {{info['username']}}
          - email: {{info['username']}}
          - password: {{info['password']}}
          - role: admin
          - require:
              - keystone: admin-role
        {% endfor %}
