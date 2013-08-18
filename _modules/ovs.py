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


# Temporary until I can the states straightened out, the following belongs
# in a _state

ovs = salt.modules.ovs

def _changeset(status,changes,comment):
     return {
        'status': status,
        'changes': changes,
        'comment': comment
    }

def bridged(bridge_name,ports=None):
    if not ports:
        ports = []
    changes = {}
    status = True
    comment = ""
    
    if not ovs._bridge_exists(bridge_name):
        ret = ovs.add_bridge(bridge_name)
        if isinstance(ret,dict):
            # The bridge was created, log it and move on.
            changes[bridge_name] = ret
        elif isinstance(ret,bool) and ret == False:
            # This would mean that the bridge was not successfully created
            # so we have to stop here.
            error = {
                bridge_name: "An error occurred while creating bridge"
            }
            comment = "Failed to create bridge {bridge}".format(bridge=bridge_name)
            return _changeset(False,error,comment)
    if ports:
        for port in ports:
            if not ovs._port_exists(bridge_name,port):
                ret = ovs.port_add(bridge_name,port)
                if isinstance(ret,dict):
                    changes[bridge_name]['ports'][port] = ret
                elif isinstance(ret,bool) and ret == False:
                    error = {
                        port: "An error occurred while adding the port"
                    }
                    comment = "Failed to add port {port} to bridge {bridge}".format(port=port,bridge=bridge_name)
                    return _changeset(False,error,comment)
    if changes:
        comment = "Bridge updated."
    else:
        comment = "Bridge in correct state"
    
    return _changeset(True,changes,comment)
                
