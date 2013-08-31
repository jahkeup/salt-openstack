{% set openstack = pillar['openstack'] %}

service-tenant:
  keystone.tenant_present:
    - name: service
    - description: Service Tenant
    - users:
        {% for service in ['nova','quantum','cinder','glance'] %}
        {% set info = openstack[service]['service'] %}

        {{service}}:
          - name: {{info['username']}}
          - email: {{info['username']}}
          - password: {{info['password']}}
        {% endfor %}
