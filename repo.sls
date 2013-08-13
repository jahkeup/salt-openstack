# Repo state for Openstack

'ubuntu-cloud-keyring':
  pkg.installed:
    - order: 1

# 'deb http://archive.gplhost.com/debian grizzly main':
#   pkgrepo.managed
# 'deb http://archive.gplhost.com/debian grizzly-backports main':
#   pkgrepo.managed

# 'gplhost-archive-keyring':
#   pkg.installed:
#     - skip_verify: True
#     - require:
#       - pkgrepo: 'deb http://archive.gplhost.com/debian grizzly main'
