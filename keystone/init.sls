{% set openstack = pillar['openstack'] -%}
{% set keystone = openstack['keystone'] -%}
{% set auth = openstack['auth'] -%}
{% set authurl = auth.get('proto','http') + "://"+ auth['server'] -%}
{% set authpass = keystone['service']['password'] -%}

# This state assumes that the database is already installed &
# provisioned, this also includes the necessary grants and users. The
# installation will succeed if the database isn't configured however,
# the services will fail to remain started and will throw errors in
# /var/log/keystone

include:
  - openstack.repo
  - openstack.patch.kombu
  - openstack.keystone.user

keystone:
  pkg.installed:
    - pkgs:
      - keystone
      - python-keystone
      - python-mysqldb
      - python-keystoneclient
    - require:
      - sls: openstack.patch.kombu
      - user: keystone-user
  file.managed:
    - name: /etc/keystone/keystone.conf
    - source: salt://openstack/keystone/conf/keystone.conf
    - template: jinja
    - user: keystone
    - group: keystone
    - require: 
      - pkg: keystone
  service.running:
    - enable: True
    - require:
      - pkg: keystone
    - watch:
      - file: keystone
      - cmd: sync-keystone-db

sync-keystone-db:
  cmd.wait:
    - name: "keystone-manage db_sync"
    - watch:
      - pkg: keystone
      - file: keystone
    - require:
      - pkg: keystone 
      - file: keystone

keystonerc:
  file.managed:
    - name: /root/keystonerc
    - mode: 400
    - user: root
    - group: root
    - contents: |
        # export OS_USERNAME=admin
        # export OS_TENANT_NAME="Default Tenant"
        # export OS_PASSWORD={{authpass}}
        export SERVICE_TOKEN={{authpass}}
        # export OS_AUTH_URL="{{authurl}}:{{auth.get('public_port',5000)}}/v2.0/"
        export SERVICE_ENDPOINT="{{authurl}}:{{auth.get('port',35357)}}/v2.0/"

