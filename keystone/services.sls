{% set openstack = pillar['openstack'] %}

service-tenant:
  keystone.tenant_present:
    - name: service
    - description: Service Tenant
    - connection_endpoint: http://33.33.33.10:35357/v2.0/
    - connection_token: keystonepass
    - users:
        {% for service in ['nova','quantum','cinder','glance'] %}
        {% set info = openstack[service]['service'] %}

        {{service}}:
           - name: {{info['username']}}
           - email: {{info['username']}}
           - password: {{info['password']}}
        {% endfor %}
