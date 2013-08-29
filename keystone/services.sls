{% set openstack = pillar['openstack'] %}

service-tenant:
  keystone.service_present:
    - name: service
    - description: Service Tenant

{% for service in ['nova','quantum','cinder','glance','swift'] %}
{% set setup = pillar['openstack'][service]['service'] -%}
{% set tenant = salt['keystone.tenant_get'](openstack['auth']['service']) %}
{% if not tenant.get('Error') %}
{{service}}-service-user:
  keystone.user_present:
    - name: {{setup['username']}}
      - password: {{setup['password']}}
      - tenant_id: {{salt['keystone.tenant_get'](openstack['auth']['service'])['id']}}
      - require: 
          - keystone.service_present: service-tenant
{% endif %}
{% endfor %}
