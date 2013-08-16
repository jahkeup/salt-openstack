#!/usr/bin/env bash
set -e

# This script adds the necessary bridges for quantum/neutron to use vlan network
# type. This script is meant to be called by salt.
# example: ./setup_bridges -p br-osgn -pb eth2 -i br-int

integration_bridge=br-int
physical_bridge=
physical_port=

function usage {
cat <<EOF

USAGE: $0 options

This script adds bridges to openvswitch for quantum to use.

-p	Physical Bridge Name
-pb	Physical Bridged Port
-i	Integration Bridge Name (default: br-int)
-h	Show this message

EOF
}

function load_bridges {
    ovs-vsctl list-br
}

function bridge_exist {
    local bridges="`load_bridges`"
    if [ -z "echo $bridges | grep $1" ]; then
	return 0
    else
	return 1
    fi
}

function create_bridge {
    ovs-vsctl add-br $1
}

while getopts "p:pb:i:h" opt; do
    case $opt in
	p)
	    physical_bridge=$OPTARG
	    ;;
	pb)
	    physical_port=$OPTARG
	    ;;
	i)
	    integration_bridge=$OPTARG
	    ;;
	h)
	    usage; exit 0;
	    ;;
    esac
done

for br in $physical_bridge $integration_bridge; do
    if [ $(bridge_exist $br) -eq 0 ]; then
        create_bridge $br
    fi
done

if [ $(bridge_exist $physical_bridge) -eq 1 ]; then
    ovs-vsctl port-add $physical_bridge $physical_port
fi
