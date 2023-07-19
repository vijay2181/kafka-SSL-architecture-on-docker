#!/bin/bash


KAFKA_TOPIC=$1
REPLICATION=${2:-3}
PARTITIONS=${3:-3}

[ -v $KAFKA_TOPIC ] && { echo "Please provide kafka topic name you wish to create?" ; exit 1 ; }

CMD="--create --if-not-exists --bootstrap-server kafka1:9093,kafka2:9093,kafka3:9093 --command-config /tmp/root.properties --replication-factor $REPLICATION --partitions $PARTITIONS --topic $KAFKA_TOPIC"

docker run --rm -it -v $(pwd):/tmp --network  kafka-ssl-architecture-on-docker_default --entrypoint /opt/bitnami/kafka/bin/kafka-topics.sh bitnami/kafka:3.1.0 $CMD
