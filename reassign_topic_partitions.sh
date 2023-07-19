#!/bin/bash

#https://sleeplessbeastie.eu/2022/01/05/how-to-reassign-kafka-topic-partitions-and-replicas/

KAFKA_TOPIC=$1


[ -v $KAFKA_TOPIC ] && { echo "Please provide the kafka topic name you wish to reassign parition to new node?" ; exit 1 ; }
TYPE=$2
[ -v $TYPE ] && { echo "Please provide any out of these as command line argument - 'verify' 'execute' generate'" ; exit 1 ; }

if [[ ! -f ${KAFKA_TOPIC}_topics.json ]];then
cat << EOF | tee ${KAFKA_TOPIC}_topics.json
{
  "topics": [
    {"topic": "$KAFKA_TOPIC"}
  ],
  "version":1
}
EOF
fi


case $TYPE in
generate)
CMD="--generate --topics-to-move-json-file /tmp/${KAFKA_TOPIC}_topics.json --bootstrap-server kafka1:9093,kafka2:9093,kafka3:9093 --command-config /tmp/root.properties --broker-list 3,4,5"
;;
verify)
CMD="--verify --reassignment-json-file /tmp/${KAFKA_TOPIC}_topic.reassign.json --bootstrap-server kafka1:9093,kafka2:9093,kafka3:9093 --command-config /tmp/root.properties"
;;
execute)
CMD="--execute --reassignment-json-file /tmp/${KAFKA_TOPIC}_topic.reassign.json --bootstrap-server kafka1:9093,kafka2:9093,kafka3:9093 --command-config /tmp/root.properties"
;;
esac


case $TYPE in
generate)
docker run --rm -it -v $(pwd):/tmp --network kafka-ssl-architecture-on-docker_default --entrypoint /opt/bitnami/kafka/bin/kafka-reassign-partitions.sh bitnami/kafka:3.1.0 $CMD | tee >(awk -F: '/Current partition replica assignment/ { getline; print $0 }' | jq > ${KAFKA_TOPIC}_topic.current.json) >(awk -F: '/Proposed partition reassignment configuration/ { getline; print $0 }' | jq >${KAFKA_TOPIC}_topic.proposed.json)
;;
*)
docker run --rm -it -v $(pwd):/tmp --network kafka-ssl-architecture-on-docker_default --entrypoint /opt/bitnami/kafka/bin/kafka-reassign-partitions.sh bitnami/kafka:3.1.0 $CMD
;;
esac

if [[ -f ${KAFKA_TOPIC}_topic.proposed.json ]];then
jq 'del(.partitions[] | .log_dirs)' ${KAFKA_TOPIC}_topic.proposed.json > ${KAFKA_TOPIC}_topic.reassign.json
fi
