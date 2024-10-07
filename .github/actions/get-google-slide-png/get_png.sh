#!/bin/bash

# Exit on any error
set -e

# Check if the required environment variables are set
if [ -z "$PRESENTATION_ID" ]; then
  echo "Error: PRESENTATION_ID is not set"
  exit 1
fi

# Check if the required environment variables are set
if [ -z "$SLIDE_ID" ]; then
  echo "Error: SLIDE_ID is not set"
  exit 1
fi

if [ -z "$OUTPUT_FILE" ]; then
  echo "Error: OUTPUT_FILE is not set"
  exit 1
fi

# Download the slide as PNG
echo "Downloading the slide from: $SHEET_URL"
curl -L "https://docs.google.com/presentation/d/$PRESENTATION_ID/export/png?pageid=$SLIDE_ID" -o "$OUTPUT_FILE"

echo "Saved slide as PNG to: $OUTPUT_FILE"
