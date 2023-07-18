#!/bin/bash

check_zk () {
HOST=$1
PORT=$2
echo "Waiting for $HOST to launch on port $PORT..."
while ! timeout 1 bash -c "echo > /dev/tcp/$HOST/$PORT"; do   
  sleep 1
done
echo "$HOST is up on port $PORT"
}

SERVER=$1
[[ -z $SERVER ]] && { echo "Please provide Zookeeper server details" ; exit 1 ; }

if [[ -n $SERVER ]];then
IFS=','; for name in $SERVER; do
    IFS=':' read -a NAME <<< "$name"
    check_zk ${NAME[0]} ${NAME[1]}
   done
fi
