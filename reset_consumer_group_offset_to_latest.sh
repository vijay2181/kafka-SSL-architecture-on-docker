#!/bin/bash
#https://sleeplessbeastie.eu/2021/11/15/how-to-reset-offset-of-kafka-consumer-group/

CONSUMER_GROUP=$1
KAFKA_TOPIC=$2

[ -v $CONSUMER_GROUP ] && { echo "Please provide consumer group name to reset offsets?" ; exit 1 ; }
[ -v $KAFKA_TOPIC ] && { echo "Please provide kafka topic name to reset offset consumer offets" ; exit 1 ; }


CMD="--group $CONSUMER_GROUP --topic $KAFKA_TOPIC  --reset-offsets --to-latest --execute --bootstrap-server kafka1:9093,kafka2:9093,kafka3:9093 --command-config /tmp/root.properties"

docker run --rm -it -v $(pwd):/tmp --network kafka-ssl-architecture-on-docker_default
t --entrypoint /opt/bitnami/kafka/bin/kafka-consumer-groups.sh bitnami/kafka:3.1.0 $CMD
