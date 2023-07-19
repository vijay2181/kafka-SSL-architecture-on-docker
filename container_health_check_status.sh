#!/bin/bash

#https://www.couchbase.com/blog/docker-health-check-keeping-containers-healthy/

docker inspect --format='{{json .State.Health}}' kafka1
