"""
Openvswitch Module

This module allows the management of OVS on a given minion. 

Functions available:

br-int:
  ovs.add_bridge

br-int:
  ovs.add_port:
    - port: eth0
br-int:
  ovs.remove_bridge

br-int:
  ovs.remove_port:
    - port: eth0

The state file contains the bridged and absent functions:

br-int:
  ovs.bridged:
    - ports:
        - eth1
        - eth2
br-int:
  ovs.absent

"""

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

def _bridge_ports(bridge_name):
    if not _bridge_exists(bridge_name):
        return []
    cmd = "list-ports {bridge_name}".format(bridge_name=bridge_name)
    ret = _ovs(cmd)
    if ret:
        lines = ret['stdout'].splitlines()
        return [line.strip() for line in lines]
    
def _port_exists(bridge_name,port):
    bridge_ports = _bridge_ports(bridge_name)
    if bridge_ports:
        try:
            if bridge_ports.index(port):
                return True
        except ValueError:
            return False

    else:
        return False

def bridges():
    """List all bridges managed by ovs
    """
    ret = _ovs('list-br')
    if ret:
        return ret['stdout']
    else:
        return False

def add_bridge(bridge_name):
    """Create bridge to be managed with ovs
    """
    if not _bridge_exists(bridge_name):
        cmd = "add-br {bridge_name}".format(bridge_name=bridge_name)
        ret = _ovs(cmd)
        if ret:
            return {
                'bridge': "Added {bridge_name}".format(bridge_name=bridge_name)
            }
        else:
            return False
    else:
        return "Bridge exists already"

def remove_bridge(bridge_name):
    """Remove managed ovs bridge and ports if they exist
    """
    changes = {}
    if not _bridge_exists(bridge_name):
        return "Bridge does not exists."
    bridge_ports = _bridge_ports(bridge_name)
    for port in bridge_ports:
        changes[port] = remove_port(bridge_name,port)
    cmd = "del-br {bridge_name}".format(bridge_name=bridge_name)
    ret = _ovs(cmd)
    if ret:
        return {
            'bridge': 'Deleted {bridge_name}'.format(bridge_name=bridge_name),
            'affected': changes
        }
    else:
        return False

def add_port(bridge_name,port):
    """Add port (network interface) to an ovs bridge.
   
    Bridge *must* exist.
    """
    if not _bridge_exists(bridge_name):
        return False

    if _port_exists(bridge_name,port):
        msg = "Port {port} is already attached to {bridge}"
        return msg.format(port=port,bridge=bridge_name)
        
    cmd = "add-port {bridge_name} {port}".format(bridge_name=bridge_name,
                                                     port=port)
    ret = _ovs(cmd)
    if ret:
        return True
    else:
        return False

def remove_port(bridge_name,port):
    if not _bridge_exists(bridge_name):
        return False

    if _port_exists(bridge_name,port):
        msg = "Port {port} is already attached to {bridge}"
        return msg.format(bridge=bridge_name,port=port)
    
    cmd = "del-port {bridge} {port}".format(bridge_name=bridge_name,
                                            port=port)
    ret = _ovs(cmd)
    if ret:
        return {
            'port': 'Port {port} deleted from {bridge}'.format(bridge=bridge_name,
                                                               port=port)
        }
    else:
        return "False"

