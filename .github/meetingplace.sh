#!/bin/bash
declare -a Chapters=(
    "womeninrobotics"
    "women-in-robotics-Boston"
    "women-in-robotics-bay-area"
    "women-in-robotics-boulder-denver"
    "women-in-robotics-bristol"
    "women-in-robotics-delhi"
    "women-in-robotics-new-york"
    "womeninroboticsmelbourne"
    "women-in-robotics-brisbane"
)

# Get all chapter events
for chapter in ${Chapters[@]}; do
    curl -s "https://meetingplace.io/api/v1/group/${chapter}/events" | jq '.' > _data/wir_events_${chapter}.json
done

# Combine all chapter events
jq -s '[.[][]]' _data/wir_events*.json > _data/events.json

# Get all chapter past events
for chapter in ${Chapters[@]}; do
    curl -s "https://meetingplace.io/api/v1/group/${chapter}/past_events" | jq '.' > _data/wir_past_events_${chapter}.json
done

#Combine all past chapter events
jq -s '[.[][]]' _data/wir_past_events*.json > _data/past_events.json
