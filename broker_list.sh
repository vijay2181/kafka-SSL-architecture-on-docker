#!/bin/bash
. functions.sh "$1"

function get_all_active_brokers {
broker_ids=$(get_broker_ids)
for broker_id in $broker_ids
do
    echo "broker_id="${broker_id/,/}
done
}

get_all_active_brokers
