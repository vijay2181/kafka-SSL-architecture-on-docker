#!/bin/bash

#https://www.conduktor.io/kafka/kafka-consumer-group-management-cli-tutorial

CONSUMER_GROUP=$1

[ -v $CONSUMER_GROUP ] && { echo "Please provide consumer group name you wish to delete?" ; exit 1 ; }


CMD="--delete --group $CONSUMER_GROUP --bootstrap-server kafka1:9093,kafka2:9093,kafka3:9093 --command-config /tmp/root.properties"

docker run --rm -it -v $(pwd):/tmp --network kafka-ssl-architecture-on-docker_default --entrypoint /opt/bitnami/kafka/bin/kafka-consumer-groups.sh bitnami/kafka:3.1.0 $CMD
