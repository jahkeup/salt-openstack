include:
  - openstack.nova.user

'/etc/nova':
  file.directory:
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
      - file: '/etc/nova'
{% endfor %}