#!/bin/bash

# Exit on any error
set -e

# Check if the required environment variables are set
if [ -z "$RSS_URL" ]; then
  echo "Error: RSS_URL is not set"
  exit 1
fi

if [ -z "$POSTS_DIR" ]; then
  echo "Error: POSTS_DIR is not set"
  exit 1
fi

# Install xmlstarlet for XML parsing
sudo apt-get update && sudo apt-get install -y xmlstarlet

# Create posts directory if it doesn't exist
mkdir -p "$POSTS_DIR"

# Fetch RSS feed
echo "Fetching RSS feed from: $RSS_URL"
RSS_CONTENT=$(curl -s "$RSS_URL")

# Parse RSS feed and extract items as separate XML blocks
echo "Parsing RSS feed..."
# Extract each item as a complete XML block
ITEM_COUNT=$(echo "$RSS_CONTENT" | xmlstarlet sel -t -v "count(//item)" -)
echo "Found $ITEM_COUNT items in RSS feed"

# Process each item by extracting fields individually
for i in $(seq 1 $ITEM_COUNT); do
  # Extract each field for the current item
  TITLE=$(echo "$RSS_CONTENT" | xmlstarlet sel -t -v "//item[$i]/title" -)
  LINK=$(echo "$RSS_CONTENT" | xmlstarlet sel -t -v "//item[$i]/link" -)
  PUB_DATE=$(echo "$RSS_CONTENT" | xmlstarlet sel -t -v "//item[$i]/pubDate" -)
  
  # Try to extract image from enclosure first
  IMAGE=$(echo "$RSS_CONTENT" | xmlstarlet sel -t -v "//item[$i]/enclosure/@url" - 2>/dev/null || echo "")
  
  # If no image in enclosure, try to extract from description CDATA
  if [ -z "$IMAGE" ]; then
    DESCRIPTION=$(echo "$RSS_CONTENT" | xmlstarlet sel -t -v "//item[$i]/description" -)
    # Extract the first image src from the HTML content
    IMAGE=$(echo "$DESCRIPTION" | grep -o 'src="[^"]*"' | head -1 | sed 's/src="//' | sed 's/"//' || echo "")
  fi
    
    # Skip if no title found
  if [ -z "$TITLE" ]; then
    echo "No title found for item $i, skipping"
    continue
  fi
  
  # Convert pubDate to YYYY-MM-DD format
  DATE=$(date -d "$PUB_DATE" +%Y-%m-%d 2>/dev/null || date -jf "%a, %d %b %Y %H:%M:%S %z" "$PUB_DATE" +%Y-%m-%d 2>/dev/null || echo "2024-01-01")
  
  # Create filename from title and date
  # Sanitize title: lowercase, replace spaces and special chars with hyphens
  SANITIZED_TITLE=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//g' | sed 's/-$//g')
  FILENAME="${DATE}-${SANITIZED_TITLE}.md"
  FILEPATH="$POSTS_DIR/$FILENAME"
  
  # Check if file already exists
  if [ -f "$FILEPATH" ]; then
    echo "Post already exists: $FILENAME"
    continue
  fi
  
  echo "Creating new post: $FILENAME"
  echo "Title: $TITLE"
  echo "Link: $LINK"
  echo "Image: $IMAGE"
  
  # Create Jekyll front matter (minimal format like existing posts)
  cat > "$FILEPATH" << EOF
---
title: $TITLE
image: $IMAGE
link: $LINK
---
EOF
  
  echo "Created post: $FILEPATH"
done

echo "RSS feed processing complete."
