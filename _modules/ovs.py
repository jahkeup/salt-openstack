"""
Openvswitch Module

This module allows the management of OVS on a given minion. 

*Requires openvswitch-switch to be installed and service running.*

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

import logging

log = logging.getLogger(__name__)

def ovs(cmd):
    """
    OVS Command runner,
    
    Returns either the dict or False if it fails to run
    """
    command= 'ovs-vsctl {cmd}'.format(cmd=cmd)
    ret = __salt__['cmd.run_all'](command)
    if ret['retcode'] == 0:
        return ret
    else:
        log.error("Command '{cmd}' failed to exit with zero-status".format(cmd=cmd))
        return False

def bridge_exists(name):
    """
    True or False, does the bridge exist?
    """
    ret = ovs('list-br')
    if ret:
        lines = ret['stdout'].splitlines()
        for line in lines:
            if line.rstrip() == name:
                return True
        return False

def bridge_ports(name):
    """
    Returns a list of ports connected to the specified bridge
    """
    if not bridge_exists(name):
        return []
    cmd = "list-ports {name}".format(name=name)
    ret = ovs(cmd)
    if ret:
        lines = ret['stdout'].splitlines()
        return [line.strip() for line in lines]
    
def port_exists(name,bridge):
    """
    True or False, does the specified port exist on the bridge?
    """
    bridges_ports = bridge_ports(bridge)
    
    if bridges_ports:
        if name in bridges_ports:
            return True
        else:
            return False

    return False

def bridges():
    """List all bridges managed by ovs
    """
    ret = ovs('list-br')
    if ret:
        return ret['stdout']
    else:
        return False

def add_bridge(name):
    """Create bridge to be managed with ovs
    """
    if not bridge_exists(name):
        cmd = "add-br {name}".format(name=name)
        ret = ovs(cmd)
        if ret:
            return {
                'bridge': "Added {name}".format(name=name)
            }
        else:
            return False
    else:
        return "Bridge exists already"

def remove_bridge(name):
    """Remove managed ovs bridge and ports if they exist
    """
    changes = {}
    if not bridge_exists(name):
        return "Bridge does not exists."
    bridge_ports = bridge_ports(name)
    for port in bridge_ports:
        changes[port] = remove_port(port,name)
    cmd = "del-br {name}".format(name=name)
    ret = ovs(cmd)
    if ret:
        return {
            'bridge': 'Deleted {name}'.format(name=name),
            'affected': changes
        }
    else:
        return False

def add_port(name,bridge):
    """Add port (network interface) to an ovs bridge.
   
    Bridge *must* exist.
    """
    if not bridge_exists(bridge):
        return False

    if port_exists(name,bridge):
        msg = "Port {port} is already attached to {bridge}"
        return msg.format(port=name,bridge=bridge)
        
    cmd = "add-port {bridge} {port}".format(bridge=bridge,
                                            port=name)
    ret = ovs(cmd)
    if ret:
        return {
            'port': 'Added port {port} to {bridge}'.format(port=name,
                                                           bridge=bridge)
        }
    else:
        return False

def remove_port(name,bridge):
    """
    Remove Port from bridge
    """
    if not bridge_exists(bridge):
        return False

    if port_exists(name,bridge):
        msg = "Port {port} is already attached to {bridge}"
        return msg.format(bridge=bridge,port=name)
    
    cmd = "del-port {bridge} {port}".format(bridge=bridge,
                                            port=name)
    ret = ovs(cmd)
    if ret:
        return {
            'port': 'Port {port} deleted from {bridge}'.format(bridge=bridge,
                                                               port=name)
        }
    else:
        return "False"

def ports(name):
    return bridge_ports(name)
