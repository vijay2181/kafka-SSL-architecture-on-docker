#!/bin/bash

echo "Stopping cluster"
docker-compose -f kafka-zk-compose-ssl.yaml down

