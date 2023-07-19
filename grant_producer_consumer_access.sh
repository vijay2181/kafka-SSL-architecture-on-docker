#!/bin/bash


USER_NAME=$1
KAFKA_TOPIC=$2
ACCESS_TYPE=$3
CONSUMER_GROUP=$4

[ -v $USER_NAME ] && { echo "Please provide username- which need access to topic?" ; exit 1 ; }
[ -v $KAFKA_TOPIC ] && { echo "Please provide kafka topic name user need access to?" ; exit 1 ; }
[ -v $ACCESS_TYPE ] && { echo "Please provide if user need producer or consumer access?" ; exit 1 ; }

if [[ $ACCESS_TYPE == producer ]];then
CMD="--bootstrap-server kafka1:9093,kafka2:9093,kafka3:9093 --add --allow-principal User:CN=$USER_NAME,OU=Devops,O=Devopsforall,L=Hyderabad,C=IN --$ACCESS_TYPE --topic $KAFKA_TOPIC --command-config /tmp/root.properties"
elif [[ $ACCESS_TYPE == consumer ]];then
if [[ $CONSUMER_GROUP =~ [a-z][A-Z]* ]];then
CMD="--bootstrap-server kafka1:9093,kafka2:9093,kafka3:9093 --add --allow-principal User:CN=$USER_NAME,OU=Devops,O=Devopsforall,L=Hyderabad,C=IN --$ACCESS_TYPE --topic $KAFKA_TOPIC --group ${CONSUMER_GROUP} --command-config /tmp/root.properties"
else
CMD="--bootstrap-server kafka1:9093,kafka2:9093,kafka3:9093 --add --allow-principal User:CN=$USER_NAME,OU=Devops,O=Devopsforall,L=Hyderabad,C=IN --$ACCESS_TYPE --topic $KAFKA_TOPIC --group=* --command-config /tmp/root.properties"
fi
fi

docker run --rm -it -v $(pwd):/tmp --network kafka-ssl-architecture-on-docker_default --entrypoint /opt/bitnami/kafka/bin/kafka-acls.sh bitnami/kafka:3.1.0 $CMD
