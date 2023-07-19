#!/bin/bash

#first connet any zookeeper container and then use below command  to list brokers

.bin/zkCli.sh -server zk1:2181
ls /brokers/ids

or

./bin/zookeeper-shell.sh localhost:2181 ls /brokers/ids
