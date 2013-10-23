include:
  - openstack.repo
  - openstack.neutron.user
  - openstack.neutron.ovs

neutron-client:
  pkg.installed:
    - pkgs:
        - python-neutron
        - neutron-common
        - python-neutronclient
    - require:
        - user: neutron
