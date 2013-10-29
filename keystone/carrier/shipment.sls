{% set openstack = pillar['openstack'] -%}
{% set keystone = openstack['keystone'] -%}
{% set auth = openstack['auth'] -%}
{% set authurl = auth.get('proto','http') + "://"+ auth['server'] -%}
{% set authpass = keystone['service']['password'] -%}
{% set staging = "/srv/container" %}

include:
  - openstack.keystone.user
keystone-conf:
  file.managed:
    - name: {{staging}}/keystone/keystone.conf
    - source: salt://openstack/keystone/conf/keystone.conf
    - template: jinja
    - user: keystone
    - group: keystone
keystonerc:
  file.managed:
    - name: /root/openrc
    - mode: 400
    - user: root
    - group: root
    - contents: |
        export OS_USERNAME=admin
        export OS_TENANT_NAME="Default Tenant"
        export OS_PASSWORD={{authpass}}
        export OS_AUTH_URL="{{authurl}}:{{auth.get('public_port',5000)}}/v2.0/"
        # export SERVICE_TOKEN={{authpass}}
        # export SERVICE_ENDPOINT="{{authurl}}:{{auth.get('port',35357)}}/v2.0/"

