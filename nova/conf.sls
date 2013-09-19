include:
  - openstack.nova.user

/etc/nova:
  - user: nova
  - group: nova
  - require:
      - user: nova-user

{% for conf in 'nova.conf','api-paste.ini','policy.json' %}
'/etc/nova/{{conf}}':
  file.managed:
    - source: salt://openstack/nova/conf/{{conf}}
    - template: jinja
    - user: nova
    - group: nova
    - require:
      - user: nova-user 
      - file.directory: '/etc/nova'
{% endfor %}