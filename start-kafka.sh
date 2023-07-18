#!/bin/bash

#waiting for zookpers to be up
wait-for-zk.sh "${ZK_SERVER}"

cp /broker/kafka.properties /broker/kafka${BROKER_ID}.properties

sed -i "/^log4j.logger.kafka.authorizer.logger=/s;=.*$;=DEBUG, authorizerAppender;" /kafka/config/log4j.properties

echo "broker.id=${BROKER_ID}" >> /broker/kafka${BROKER_ID}.properties
echo "listeners=SSL://kafka${BROKER_ID}:9093" >> /broker/kafka${BROKER_ID}.properties
echo "advertised.listeners=SSL://kafka${BROKER_ID}:9093" >> /broker/kafka${BROKER_ID}.properties
echo "ssl.keystore.location=/kafka${BROKER_ID}/kafka${BROKER_ID}.keystore.jks"  >> /broker/kafka${BROKER_ID}.properties
echo "ssl.truststore.location=/kafka${BROKER_ID}/kafka${BROKER_ID}.truststore.jks" >>  /broker/kafka${BROKER_ID}.properties

#Start kafka
/kafka/bin/kafka-server-start.sh  /broker/kafka${BROKER_ID}.properties

tail -f /dev/null
