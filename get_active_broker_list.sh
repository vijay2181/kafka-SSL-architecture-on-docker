#!/bin/bash

SERVER=${1}

[ -v $SERVER ] && { echo "Please provide zookeper server name and try again." ; exit 1 ; }
CMD="/tmp/broker_list.sh $SERVER"

if [[ ! -n $(docker images -q kafka-broker-list) ]];then
docker build -t kafka-broker-list -f dockerfile.broker_list .
fi

printf "Getting info of number of kafka brokers in cluster.."
echo " OK!"
docker run --rm -it -v $(pwd):/tmp -w /tmp --network kafka_default --entrypoint bash kafka-broker-list $CMD
