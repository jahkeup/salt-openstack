{% set staging = '/srv/container/rabbit/conf' -%}

rabbit-conf:
  file.directory:
    - name: {{staging}}
    - makedirs: True

rabbit-users:
  file.managed:
    - name: {{staging}}/rabbit_passwords.txt
    - mode: 0400
    - contents: |
        guest:{{pillar['openstack']['rabbit']['password']}}

        
