#!/bin/bash

echo "${ZK_ID}" > /zookeeper/data/myid

cp -r /zk${ZK_ID}/zk${ZK_ID}.cfg /zookeeper/conf/
/zookeeper/bin/zkServer.sh start /zk${ZK_ID}/zk${ZK_ID}.cfg

tail -f /dev/null
