def __virtual__():
    return "ovs"

def _ovs(cmd):
    command= 'ovs-vsctl {cmd}'.format(cmd=cmd)
    ret = __salt__['cmd.run_all'](command)
    if ret['retcode'] == 0:
        return ret
    else:
        return False

def _bridge_exists(bridge_name):
    ret = _ovs('list-br')
    if ret:
        lines = ret['stdout'].splitlines()
        for line in lines:
            if line.rstrip() == bridge_name:
                return True
        return False

def _port_exists(bridge_name,port):
    cmd = "list-ports {bridge_name}".format(bridge_name=bridge_name)
    ret = _ovs(cmd)
    if ret['retcode'] == 0:
        for line in ret['stdout'].splitlines():
            if line.rstrip() == port:
                return True
        return False
    else:
        return False

def bridges():
    ret = _ovs('list-br')
    if ret:
        return ret['stdout']
    else:
        return False

def add_bridge(bridge_name):
    if not _bridge_exists(bridge_name):
        cmd = "add-br {bridge_name}".format(bridge_name=bridge_name)
        ret = _ovs(cmd)
        if ret['retcode'] == 0:
            return True
        else:
            return ret['stderr']
    else:
        return True

def add_port(bridge_name,port):
    if not _bridge_exists(bridge_name):
        return False
    elif not _port_exists(bridge_name,port):
        cmd = "add-port {bridge_name} {port}".format(bridge_name=bridge_name,
                                                     port=port)
        ret = _ovs(cmd)
        if ret['retcode'] == 0:
            return True
        else:
            return False
    else:
        return True
