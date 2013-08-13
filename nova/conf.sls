{% for conf in 'nova.conf','api-paste.ini','policy.json' %}

'/etc/nova/{{conf}}':
  file.managed:
    - source: salt://openstack/nova/conf/{{conf}}
    - template: jinja
    - require:
      - file.directory: '/etc/nova'
{% endfor %}