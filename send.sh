#!/bin/bash
curl -L -H 'Content-Type: application/json' -X POST -d @docker.json 192.168.65.141:5465/scheduler/iso8601 
