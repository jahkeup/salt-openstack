import salt.modules.ovs

ovs = salt.modules.ovs

def __virtual__():
    return "ovs"

def _changeset(status,changes,comment):
     return {
        'status': status,
        'changes': changes,
        'comment': comment
    }

def bridged(bridge_name,ports=None):
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
            comment = "Failed to create bridge {bridge}"
            comment = comment.format(bridge=bridge_name)
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
                    comment = "Failed to add port {port} to bridge {bridge}"
                    comment = comment.format(port=port,bridge=bridge_name)
                    return _changeset(False,error,comment)
    if changes:
        comment = "Bridge updated."
    else:
        comment = "Bridge in correct state"
    
    return _changeset(True,changes,comment)

