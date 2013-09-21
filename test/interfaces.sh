#!/usr/bin/env bash

ip link add link lo name DB type bridge 2>&1>/dev/null
ip link add link lo name KEYSTONE type bridge 2>&1>/dev/null
ip addr add 33.33.33.10/32 dev DB 2>&1>/dev/null
ip addr add 69.43.73.66/32 dev KEYSTONE 2>&1>/dev/null
ip link set dev DB up 2>&1>/dev/null
ip link set dev KEYSTONE up 2>&1>/dev/null
