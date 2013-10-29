{% set openstack = pillar['openstack'] -%}
{% set keystone = openstack['keystone'] -%}
{% set auth = openstack['auth'] -%}
{% set authurl = auth.get('proto','http') + "://"+ auth['server'] -%}
{% set authpass = keystone['service']['password'] -%}

include:
  - openstack.keystone.user

/etc/keystone:
  file.directory:
    - mode: 755
    - user: keystone
    - group: keystone
    - require:
      - user: keystone-user

/etc/keystone/keystone.conf:
  file.managed:
    - source: salt://openstack/keystone/conf/keystone.conf
    - template: jinja
    - user: keystone
    - group: keystone
    - require:
      - file: /etc/keystone

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