"""
State module for OVS

*Requires openvswitch-switch to be installed and service running.*
"""

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
    
    if not __salt__['ovs.bridge_exists'](name):
        ret = __salt__['ovs.add_bridge'](name)
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
                
        for port in ports:
            if not __salt__['ovs.port_exists'](port,name):
                ret = __salt__['ovs.add_port'](port,name)
                if isinstance(ret,dict):
                    if not changes.get('ports'):
                        changes['ports'] = {}
                    changes['ports'][port] = ret
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

