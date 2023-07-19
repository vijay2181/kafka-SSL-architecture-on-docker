#!/bin/bash

KAFKA_TOPIC=$1

[ -v $KAFKA_TOPIC ] && { echo "Please provide kafka topic name you wish to delete?" ; exit 1 ; }


CMD="--delete --topic $KAFKA_TOPIC --bootstrap-server kafka1:9093,kafka2:9093,kafka3:9093 --command-config /tmp/root.properties"

docker run --rm -it -v $(pwd):/tmp --network kafka-ssl-architecture-on-docker_default --entrypoint /opt/bitnami/kafka/bin/kafka-topics.sh bitnami/kafka:3.1.0 $CMD
[ $? -eq 0 ] && printf "Topic $KAFKA_TOPIC deletion was successful.."
echo " Ok!"
