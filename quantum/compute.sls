include:
  - openstack.repo
  - openstack.quantum.user
  - openstack.quantum.ovs

quantum-client:
  pkg.installed:
    - pkgs:
        - python-quantum
        - quantum-common
        - python-quantumclient
    - require:
        - user: quantum
  