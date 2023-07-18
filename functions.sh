#!/bin/bash
ZOOKEEPER_SERVER="${1}"

[ -v $ZOOKEEPER_SERVER ] && { echo "Please provide zookeper server name and try again." ; exit 1 ; }

# Helper Functions Below

function get_broker_ids {
broker_ids_out=$(/zookeeper/bin/zkCli.sh -server $ZOOKEEPER_SERVER <<EOF
ls /brokers/ids
quit
EOF
)
broker_ids_csv="$(echo "${broker_ids_out}" | grep '^\[.*\]$')"
echo "$broker_ids_csv" | sed 's/\[//;s/]//;s/,/ /'
}


function get_broker_details {
broker_id="$1"
echo "$(/zookeeper/bin/zkCli.sh -server $ZOOKEEPER_SERVER <<EOF
get /brokers/ids/$broker_id
quit
EOF
)"
}


function parse_endpoint_detail {
broker_detail="$1"
json="$(echo "$broker_detail"  | grep '^{.*}$')"
json_endpoints="$(echo $json | jq .endpoints)"
echo "$(echo $json_endpoints |jq . |  grep HOST | tr -d " ")"
}
