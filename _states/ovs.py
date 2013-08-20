"""
State module for OVS

*Requires openvswitch-switch to be installed and service running.*
"""

class OvsModule(object):
    """
    drop in for ovs for the time being
    """
    def _ovs(self,cmd):
        """
        OVS Command runner,
        
        Returns either the dict or False if it fails to run
        """
        command= 'ovs-vsctl {cmd}'.format(cmd=cmd)
        ret = __salt__['cmd.run_all'](command)
        if ret['retcode'] == 0:
            return ret
        else:
            return False

    def _bridge_exists(self,name):
        """
        True or False, does the bridge exist?
        """
        ret = self._ovs('list-br')
        if ret:
            lines = ret['stdout'].splitlines()
            for line in lines:
                if line.rstrip() == name:
                    return True
            return False

    def _bridge_ports(self,name):
        """
        Returns a list of ports connected to the specified bridge
        """
        if not self._bridge_exists(name):
            return []
        cmd = "list-ports {name}".format(name=name)
        ret = self._ovs(cmd)
        if ret:
            lines = ret['stdout'].splitlines()
            return [line.strip() for line in lines]
        
    def _port_exists(self,name,bridge):
        """
        True or False, does the specified port exist on the bridge?
        """
        bridge_ports = self._bridge_ports(bridge)
        if bridge_ports:
            try:
                if bridge_ports.index(name):
                    return True
            except ValueError:
                return False

        else:
            return False

    def add_bridge(self,name):
        """Create bridge to be managed with ovs
    """
        if not self._bridge_exists(name):
            cmd = "add-br {name}".format(name=name)
            ret = self._ovs(cmd)
            if ret:
                return {
                    'bridge': "Added {name}".format(name=name),
                    'ports': None
                }
            else:
                return False
        else:
            return "Bridge exists already"
    def add_port(self,name,bridge):
        """Add port (network interface) to an ovs bridge.
    
        Bridge *must* exist.
        """
        if not self._bridge_exists(bridge):
            return False

        if self._port_exists(name,bridge):
            msg = "Port {port} is already attached to {bridge}"
            return msg.format(port=name,bridge=bridge)
        
        cmd = "add-port {bridge} {port}".format(bridge=bridge,
                                                port=name)
        ret = self._ovs(cmd)
        if ret:
            return True
        else:
            return False

# import salt.modules.ovs
# ovs = salt.modules.ovs
ovs = OvsModule()

def _changeset(name,status,changes,comment):
     return {
        'name': name,
        'result': status,
        'changes': changes,
        'comment': comment
    }

def bridged(name,ports=None):
    """
    Ensure that bridge `bridge_name` exists and attach ports `ports` to it.

    br-int:
      ovs.bridged:
        - ports:
          - eth1
          - eth2
    """
    if not ports:
        ports = []
    changes = {}
    status = True
    comment = ""
    
    if not ovs._bridge_exists(name):
        ret = ovs.add_bridge(name)
        if isinstance(ret,dict):
            # The bridge was created, log it and move on.
            changes[name] = ret
        elif isinstance(ret,bool) and ret == False:
            # This would mean that the bridge was not successfully created
            # so we have to stop here.
            error = {
                name: "An error occurred while creating bridge"
            }
            comment = "Failed to create bridge {bridge}"
            comment = comment.format(bridge=name)
            return _changeset(name,False,error,comment)
    if ports:
        changes[name] = {}
        for port in ports:
            if not ovs._port_exists(port,name):
                ret = ovs.add_port(port,name)
                if isinstance(ret,dict):
                    changes[name]['ports'][port] = ret
                elif isinstance(ret,bool) and ret == False:
                    error = {
                        port: "An error occurred while adding the port"
                    }
                    comment = "Failed to add port {port} to bridge {bridge}"
                    comment = comment.format(port=port,bridge=name)
                    return _changeset(name,False,error,comment)
    if changes:
        comment = "Bridge updated."
    else:
        comment = "Bridge in correct state"
    
    return _changeset(name,True,changes,comment)

