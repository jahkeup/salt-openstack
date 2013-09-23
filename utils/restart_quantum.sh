#!/usr/bin/env bash
salt netcontrol\* service.restart quantum-server
salt netcontrol\* service.restart quantum-l3-agent
salt netcontrol\* service.restart quantum-plugin-openvswitch-agent
salt netcontrol\* service.restart quantum-dhcp-agent
salt netcontrol\* service.restart quantum-metadata-agent
salt compute\* service.restart quantum-plugin-openvswitch-agent
