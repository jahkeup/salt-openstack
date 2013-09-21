{% set openstack = pillar['openstack'] -%}
{% set keystone = openstack['keystone'] -%}
{% set auth = openstack['auth'] -%}
{% set endpoint = auth.get('proto','http') + "://"+ auth['server']+":35357/v2.0/" -%}
{% set token = keystone['service']['password'] -%}
keystone-service:
  service.running:
    - name: keystone

admin-role:
  keystone.role_present:
    - name: admin
    - connection_endpoint: {{endpoint}}
    - connection_token: {{token}}
    - require:
      - service: keystone-service

service-tenant:
  keystone.tenant_present:
    - name: service
    - description: Service Tenant
    - connection_endpoint: {{endpoint}}
    - connection_token: {{token}}
    - require:
      - keystone: admin-role

{% for service_tenant in ['nova','quantum','cinder','glance'] %}
{% set user = openstack[service_tenant]['service'] %}

{{service_tenant}}-keystone-user:
  keystone.user_present:
    - name: {{user['username']}}
    - email: {{user['username']}}
    - password: {{user['password']}}
    - role: admin
    - connection_token: {{token}}
    - connection_endpoint: {{endpoint}}
    - require:
      - keystone: admin-role
{% endfor %}
