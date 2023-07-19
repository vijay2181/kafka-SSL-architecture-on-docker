#!/bin/bash

#https://bigdataprogrammers.com/kafka-console-producer-and-consumer-with-example/

kafka-console-consumer.sh --bootstrap-server localhost:9093 --whitelist 'sampleTopic1|sampleTopic2|sampleTopic3' --property print.key=true

