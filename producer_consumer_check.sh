#!/bin/bash

# Below scripts to check if you are able to produce and consume message from console producer and consumer

./kafka-topics.sh --create --bootstrap-server kafka1:9093 --replication-factor 3 --partitions 3 --topic test

./kafka-console-producer.sh --broker-list kafka3:9093 --topic test

./kafka-console-consumer.sh --bootstrap-server kafka1:9093 --topic test --from-beginning

echo "Hello World, this sample provided by ATA" | ./kafka-console-producer.sh --broker-list kafka1:9093 --topic ATA > /dev/null

./kafka-console-consumer.sh --bootstrap-server kafka3:9093 --topic ATA --from-beginning
