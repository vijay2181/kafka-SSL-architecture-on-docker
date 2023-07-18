#!/bin/bash

LOG_FILE=$(mktemp)
if [[ ! -n $(docker images -q kafka-broker-list) ]];then
docker build -t kafka-broker-list -f dockerfile.broker_list .
fi

function check() {
SERVER=$1
docker exec $SERVER bash -c "/zookeeper/bin/zkServer.sh status /$SERVER/${SERVER}.cfg"
}

for server in zk1:2181 zk2:2181 zk3:2181
do
echo -n "Getting info for ${server/:*/}.." >> $LOG_FILE
echo " OK!" >> $LOG_FILE
check ${server/:*/} |grep Mode >> $LOG_FILE 2>&1
done

echo "Please check the logfile $LOG_FILE - to get information - cat it"
clear
cat $LOG_FILE
