#!/bin/bash

[[ ! -d secrets ]] &&  {
printf "Please create all the SSL cert first and then start the kafka cluster.."
echo " OK!"
exit 1
}
docker-compose -f kafka-zk-compose-ssl.yaml down
