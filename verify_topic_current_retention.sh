#!/bin/bash


KAFKA_TOPIC=$1

[ -v $KAFKA_TOPIC ] && { echo "Please provide kafka topic name you wish to retention?" ; exit 1 ; }

CMD="--describe --all --bootstrap-server kafka1:9093,kafka2:9093,kafka3:9093 --command-config /tmp/root.properties --topic $KAFKA_TOPIC"

docker run --rm -it -v $(pwd):/tmp --network kafka-ssl-architecture-on-docker_default
 --entrypoint /opt/bitnami/kafka/bin/kafka-configs.sh bitnami/kafka:3.1.0 $CMD |awk 'BEGIN{IFS="=";IRS=" "} /^[ ]*retention.ms/{print $1}'|xargs
