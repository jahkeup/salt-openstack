{% set openstack = pillar['openstack'] -%}
{% set keystone = openstack['keystone'] -%}
{% set auth = openstack['auth'] -%}
{% set endpoint = auth.get('proto','http') + "://"+ auth['server']+":35357/v2.0/" -%}
{% set token = keystone['service']['password'] -%}

include:
  - openstack.keystone.services

default-tenant:
  keystone.tenant_present:
    - name: "Default Tenant"
    - description: "The default tenanancy group."
    - connection_token: {{token}}
    - connection_endpoint: {{endpoint}}
    - require:
      - service: keystone-service

default-admin:
  keystone.user_present:
    - name: admin
    - password: {{token}}
    - email: admin@cld.packetsurge.net
    - roles:
        - 'Default Tenant':
          - admin
    - tenant: "Default Tenant"
    - connection_token: {{token}}
    - connection_endpoint: {{endpoint}}
    - require:
      - keystone: default-tenant

packetsurge-tenant:
  keystone.tenant_present:
    - name: Packetsurge
    - description: Packetsurge Networks tenant
    - connection_token: {{token}}
    - connection_endpoint: {{endpoint}}
    - require:
      - service: keystone-service
