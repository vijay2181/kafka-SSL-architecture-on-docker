#!/bin/bash

#Producer with ssl

#https://stackoverflow.com/questions/58218493/kafka-and-ssl-java-lang-outofmemoryerror-java-heap-space-when-using-kafka-top
./kafka-console-producer.sh --broker-list kafka1:9092 --topic subham --producer.config /tmp/producer.properties

./kafka-console-consumer.sh --bootstrap-server kafka1:9092 --topic subham --from-beginning --consumer.config /tmp/consumer.properties

./kafka-topics.sh --create --bootstrap-server kafka1:9092 --command-config /tmp/producer.properties --replication-factor 3 --partitions 3 --topic test

./kafka-topics.sh --list  --bootstrap-server kafka1:9092 --command-config /tmp/producer.properties

./kafka-topics.sh --bootstrap-server=localhost:9092 --describe --topic users.registrations --command-config /tmp/producer.properties
