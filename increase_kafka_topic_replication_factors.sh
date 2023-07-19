#!/bin/bash
#https://gist.github.com/bb01100100/d9ca14a2378857580dbb195080c3d8c7

# Author: Kel Graham
# Date:   2022-05-19
# Purpose: Increase the replication factor of one or more topics, using only
#          a connection to the Kafka broker (no Zookeeper, REST APIs etc)
#          and the standard kafka-topics, kafka-reassign-partitions scripts
#          that come with Kafka.
#
# Note:    Assumes a recent version of Kafka (somewhere post AK2.0 where the
#          format of `kafka-topics --describe` changed)
#          See v1 of this script (https://gist.github.com/bb01100100/d9ca14a2378857580dbb195080c3d8c7)
#          for a version that used Zookeeper.

PARAMS=""

while (( "$#" )); do
  case "$1" in
    -b|--bootstrap-server)
      BOOTSTRAP_SERVER=$2
      shift 2
      ;;
    -t|--topic)
      TOPIC=$2
      shift 2
      ;;
    -r|--replica-list)
      REPLICAS=$2
      shift 2
      ;;
    -c|--command-config)
      AUTH=$2
      shift 2
      ;;
    -h|--help)
                echo ""
      echo "Alter the replication factor for a given topic"
      echo ""
      echo "Usage: $0"
      echo "  -b | --bootstrap-server <broker2:9092>"
      echo "  -t | --topic <topic name>"
      echo "  -r | --replicas <1,2,3,4>           # List of Broker IDs to replicate the topic to"
      echo "  -c | --command-config <file>        # Authentication file"
                echo ""
      echo ' Example use:'
      echo ' ./increase-replication-factor.sh -b localhost:19092 -t test-topic -r 1,2,3,4,5,6 -z -c client-auth.properties'
      exit 1
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done


# Set env vars if there are some
if [ -n "$PARAMS" ]; then
        eval set -- "$PARAMS"
fi

if [ -z "$BOOTSTRAP_SERVER" ] || [ -z "$TOPIC" ] || [ -z "$REPLICAS" ] ; then
 exec $0 -h
 exit 1
fi

# Get the partition count for the topic
CMD="kafka-topics --describe --bootstrap-server $BOOTSTRAP_SERVER "
if [ -n "$AUTH" ]; then
        CMD="${CMD} --command-config $AUTH "
fi

if [ -n "$TOPIC" ]; then
        CMD="${CMD} --topic $TOPIC "
fi


# Output topic descriptions to file so that we can crawl over them if needed.
echo "$( ${CMD} )" > topics.$$

# For each topic found in the output, iterate..
UNIQUE_TOPICS=$(cat topics.$$ | grep -E '^Topic: ' | awk '{print $2 }' | sort -u)

cat <<EOF > mapping.$$.json
{"version":1,
 "partitions":[
EOF

row_count=0
for topic in ${UNIQUE_TOPICS}; do
        echo "Working on topic $topic..."
   while read r
   do
                partition=$(echo $r | awk '{print $4}')
                leader=$(echo $r | awk '{print $6}')

                # Create a "set" of replicas, making sure the existing
      # broker leader is retained as the first replica.
                replicas=$leader
                for t in $(echo $REPLICAS | tr ',' '\n'); do
                        if [[ "$t" != "$leader" ]]; then
                                replicas="${replicas},$t"
                        fi
                done

                row_count=$(( $row_count + 1 ))
                if [[ $row_count -gt 1 ]]; then
                        echo -n "    ," >> mapping.$$.json
                else
                        echo -n "     " >> mapping.$$.json
                fi

                cat <<EOF >> mapping.$$.json
{"topic":"$topic", "partition": $partition, "replicas":[$replicas] }
EOF
        done < <(cat topics.$$ | awk -v topic=$topic '$2 == topic && $3 == "Partition:"')
done

cat <<EOF >> mapping.$$.json
  ]
}
EOF


read -n 1 -p "A partition reassignment file has been generated. Would you to see it? " SHOW_IT
case $SHOW_IT in
        [Yy]*)
        echo ""
        cat mapping.$$.json
        ;;
        [Nn]*)
esac
echo ""


read -n 1 -p "Will now reassign/expand the topic partition replicas. Ready y/n? " RUN_IT
case $RUN_IT in
        [Yy]*)
        echo ""
        RUN_REASSIGNMENT=1
        ;;
        [Nn]*)
        RUN_REASSIGNMENT=0
esac
echo ""

CMD="kafka-reassign-partitions --bootstrap-server $BOOTSTRAP_SERVER --reassignment-json-file mapping.$$.json "

if [ -n "$AUTH" ]; then
  echo "Using provided authentication config file.."
  AUTH=" --command-config $AUTH "
else
  AUTH=""
fi

if [[ $RUN_REASSIGNMENT -eq 0 ]]; then
        echo "Ok, not doing anything. "
   echo "The reassignment file \"mapping.$$.json\" has not been deleted."
   echo "Bye."
        exit 0
else
        echo "Excuting replica reassignment.. logfile is \"reassignment.log\""
fi

CMD="${CMD} ${AUTH} "

${CMD} --execute | tee reassignment.log

echo "Verifying reassignment..."
${CMD} --verify

rm -f mapping.$$.json topics.$$
