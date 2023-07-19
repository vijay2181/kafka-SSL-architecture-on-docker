#!/bin/bash

KAFKA_TOPIC=$1

[ -v $KAFKA_TOPIC ] && { echo "Please provide kafka topic name you wish to produce message to?" ; exit 1 ; }


CMD="--broker-list kafka1:9093,kafka2:9093,kafka3:9093 --topic $KAFKA_TOPIC --producer.config /tmp/producer.properties"

docker run --rm -it -v $(pwd):/tmp --network kafka-ssl-architecture-on-docker_default --entrypoint /opt/bitnami/kafka/bin/kafka-console-producer.sh bitnami/kafka:3.1.0 $CMD
