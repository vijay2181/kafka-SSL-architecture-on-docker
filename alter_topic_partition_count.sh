#!/bin/bash


KAFKA_TOPIC=$1
PARTITION_COUNT=${2:-9}

[ -v $KAFKA_TOPIC ] && { echo "Please provide kafka topic name you wish to alter partitions count?" ; exit 1 ; }
[ -v $PARTITION_COUNT ] && { echo "Please provide kafka topic partions count you wish to set new?" ; exit 1 ; }

CMD="--alter --partitions $PARTITION_COUNT --bootstrap-server kafka1:9093,kafka2:9093,kafka3:9093 --command-config /tmp/root.properties --topic $KAFKA_TOPIC"

docker run --rm -it -v $(pwd):/tmp --network kafka-ssl-architecture-on-docker_default --entrypoint /opt/bitnami/kafka/bin/kafka-topics.sh bitnami/kafka:3.1.0 $CMD
[ $? -eq 0 ] && printf "Completed updating partitions count of topic $KAFKA_TOPIC to $PARTITION_COUNT .."
echo " Ok!"
