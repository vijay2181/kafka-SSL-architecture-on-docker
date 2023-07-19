#!/bin/bash

#https://gist.github.com/marwei/cd40657c481f94ebe273ecc16601674b

kafka-consumer-groups.sh --bootstrap-server kafka-host:9092 --group my-group
--reset-offsets --to-earliest --all-topics --execute

kafka-consumer-groups.sh --bootstrap-server kafka-host:9092 --group my-group --reset-offsets --shift-by 10
--topic sales_topic --execute

kafka-consumer-groups.sh --bootstrap-server kafka-host:9092 --group my-group --reset-offsets --shift-by -10
--topic sales_topic --execute

kafka-consumer-groups.sh --bootstrap-server kafka-host:9092 --group my-group --reset-offsets
--to-datetime 2020-11-01T00:00:00Z --topic sales_topic --execute


kafka-consumer-groups.sh --bootstrap-server kafka-host:9092 --group my-group --reset-offsets --to-earliest
--topic sales_topic --execute


kafka-consumer-groups.sh --bootstrap-server kafka-host:9092 --group my-group --reset-offsets --to-latest
--topic sales_topic --execute
