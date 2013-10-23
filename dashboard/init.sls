openstack-dashboard:
  pkg:
    - installed

openstack-dashboard-ubuntu-theme:
  pkg.purged:
    - require:
      - pkg: openstack-dashboard