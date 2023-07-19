./kafka–acls.sh —bootstrap–server public_ip_of_kafka_node:9092 —command–config kafka.properties —add —deny–principal User:test —operation Write —topic test —force

./kafka–acls.sh —bootstrap–server public_ip_of_kafka_node:9092 —command–config kafka.properties —add —deny–principal User:test —operation All —topic test —force

./kafka–acls.sh —bootstrap–server public_ip_of_kafka_node:9092 —command–config kafka.properties —add —allow–principal User:test —operation Read —topic test —force

./kafka-acls.sh --bootstrap-server public_ip_of_kafka_node:9092 --command-config kafka.properties --remove --deny-principal User:test --operation Write --topic test --force

./kafka-acls.sh --bootstrap-server public_ip_of_kafka_node:9092 --command-config kafka.properties --remove --deny-principal User:test --operation All --topic test --force

./kafka-acls.sh --bootstrap-server public_ip_of_kafka_node:9092 --command-config kafka.properties --remove --allow-principal User:test --operation Read --topic test --force

./kafka-acls.sh --bootstrap-server public_ip_of_kafka_node:9092 --command-config kafka.properties --add --deny-principal User:write --operation Read --topic instaclustr --resource-pattern-type prefixed --force



 bin/kafka-acls.sh --authorizer kafka.security.auth.SimpleAclAuthorizer \
    --authorizer-properties zookeeper.connect=localhost:2181 --add \
    --allow-principal User:* --operation read --topic test --group=*
    
    
    
    
    #https://docs.huihoo.com/apache/kafka/confluent/3.1/kafka/authorization.html
   # https://docs.cloudera.com/HDPDocuments/HDP2/HDP-2.6.0/bk_security/content/kafka-acl-examples.html
    # 
   #https://sonamvermani.medium.com/kafka-acls-b1c42df9a7e2
   #https://cwiki.apache.org/confluence/display/KAFKA/Kafka+Authorization+Command+Line+Interface
