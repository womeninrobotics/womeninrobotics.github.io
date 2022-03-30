#!/bin/bash
EXIT_CODE=0

function get_events() {
    event_type=$1
    # Get all chapter events
    for chapter in $(jq -r '.[].meetingplace' _data/chapters.json); do
        echo "Retrieving ${event_type} for ${chapter}"
        curl -s "https://meetingplace.io/api/v1/group/${chapter}/${event_type}" | jq '.' > _data/wir_${event_type}_${chapter}.json
        if jq '. | has("error")' _data/wir_${event_type}_${chapter}.json &> /dev/null; then
            echo "Error retrieving ${event_type} for ${chapter}"
            EXIT_CODE=1
        fi
    done

    # Combine all chapter events
    jq -s '[.[][]]' _data/wir_${event_type}*.json > _data/${event_type}.json
}

get_events "events"
get_events "past_events"
exit $EXIT_CODE
