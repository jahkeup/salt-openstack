#!/usr/bin/env bash
salt control\* service.restart nova-api
salt control\* service.restart nova-scheduler
salt control\* service.restart nova-conductor
salt compute\* service.restart nova-compute
