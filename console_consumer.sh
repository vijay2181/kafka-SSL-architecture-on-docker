#!/bin/bash

KAFKA_TOPIC=$1

[ -v $KAFKA_TOPIC ] && { echo "Please provide kafka topic name you wish to consume message from?" ; exit 1 ; }


CMD="--bootstrap-server kafka1:9093,kafka2:9093,kafka3:9093 --topic $KAFKA_TOPIC --from-beginning --consumer.config /tmp/consumer.properties"

docker run --rm -it -v $(pwd):/tmp --network kafka-ssl-architecture-on-docker_default --entrypoint /opt/bitnami/kafka/bin/kafka-console-consumer.sh  bitnami/kafka:3.1.0 $CMD
