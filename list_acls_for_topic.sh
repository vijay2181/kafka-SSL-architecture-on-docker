#!/bin/bash


KAFKA_TOPIC=$1

[ -v $KAFKA_TOPIC ] && { echo "Please provide kafka topic name you wish to find acls for?" ; exit 1 ; }

CMD="--bootstrap-server kafka1:9093,kafka2:9093,kafka3:9093 --list --topic $KAFKA_TOPIC --command-config /tmp/root.properties"

docker run --rm -it -v $(pwd):/tmp --network kafka-ssl-architecture-on-docker_default --entrypoint /opt/bitnami/kafka/bin/kafka-acls.sh bitnami/kafka:3.1.0 $CMD
