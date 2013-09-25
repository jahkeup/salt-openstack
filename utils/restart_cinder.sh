#!/usr/bin/env bash
salt control\* service.restart cinder-api
salt control\* service.restart cinder-volume
salt control\* service.restart cinder-scheduler
