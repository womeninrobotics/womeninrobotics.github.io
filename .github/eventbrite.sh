#!/bin/bash

ORG_ID="${EVENTBRITE_ORG_ID}"
API_KEY="${EVENTBRITE_TOKEN}"

# Set up the URL to get all events for the organization
EVENTS_URL="https://www.eventbriteapi.com/v3/organizations/${ORG_ID}/events/?status=live"

# Get the events using curl and the Eventbrite API key
RESPONSE=$(curl -s -H "Authorization: Bearer ${API_KEY}" -X GET ${EVENTS_URL})

# Parse the response and save it to a JSON file
echo "${RESPONSE}" | jq '[.events[] | {id, url, name: .name.text, description: .description.html, location: .venue.name, location_info: .venue.address.localized_address_display, start_time: .start.utc, end_time: .end.utc}]' > _data/events.json
