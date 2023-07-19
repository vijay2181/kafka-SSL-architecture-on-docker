#!/bin/bash

echo "${ZK_ID}" > /zookeeper/data/myid

/zookeeper/bin/zkServer.sh start /zk${ZK_ID}/zk${ZK_ID}.cfg

tail -f /dev/null
