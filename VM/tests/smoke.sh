#!/bin/bash

#A subset of strict mode - -e would be annoying in this instance
set -u
set pipefail

#Gather an "overall" health, kinda hacky but should be OK for a smoketest
overall_status=0

echo -n 'Checking demo/hello-world container...'
timeout 2 curl -s --fail 192.168.33.10:8080 > /dev/null
if [ "$?" -eq 0 ]; then
    echo "OK"
else
    echo "error"
    overall_status=$((overall_status + 1))
fi

echo -n 'Checking local registry...'
timeout 2 curl -s --fail 192.168.33.10:5000 > /dev/null
if [ "$?" -eq 0 ]; then
    echo "OK"
else
    echo "error"
    overall_status=$((overall_status + 1))
fi

exit $overall_status
