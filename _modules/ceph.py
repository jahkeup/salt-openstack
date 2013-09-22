"""
Ceph Module

This module allows the administration of ceph pools and users 

*Requires ceph to be installed, configured, and service running.*

"""

import logging

log = logging.getLogger(__name__)
def _run_cmd(cmd):
    ret = __salt__['cmd.run_all'](cmd)
    if ret['retcode'] == 0:
        return ret
    else:
        log.error("Command '{cmd}' failed to exit with zero-status".format(cmd))
        return False

def _rados(params):
    return _run_cmd('rados {params}'.format(params=params))

def create_user(name,permissions):
    pass
def get_user_key(name):
    pass

def add_pool(name):
