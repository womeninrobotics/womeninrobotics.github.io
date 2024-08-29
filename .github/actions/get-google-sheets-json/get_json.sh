#!/bin/bash

pip install csvkit
# Get the spreadsheet as JSON
curl -L "$SHEET_URL" \
    | csvjson --indent 4 -d , \
    | jq 'map(select(. | to_entries | map(.value != null) | any))' \
    >  $OUTPUT_FILE
echo "Saved sheet to $OUTPUT_FILE."
