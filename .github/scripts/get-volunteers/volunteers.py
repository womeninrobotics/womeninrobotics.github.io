#!/usr/bin/env python3
""" md
# volunteers.py

This file grabs the volunteer information from the Women in Robotics Volunteers airtable.

You should have the following environment variables in the .env file:

- AIRTABLE_API_KEY

Generate your key from https://airtable.com/create/tokens
The airtable API for this table is located at https://airtable.com/appyWs86AFu81RRac/api/docs

"""

import os
import requests
import json
import re
from dotenv import load_dotenv
from airtable import airtable
from slugify import slugify

image_folder = "assets/images/volunteers"
data_folder = "_data"
data_file = "volunteers.json"

# Airtable ids
base_id = "appyWs86AFu81RRac"
table_id = "tblmOICNF6qQnkyCW"
field_name = "Your Name"
field_title = "Work Title"
field_company = "Company or University"
field_image = "Attach your Head Shot"
field_projects = "Your Projects"
field_qualified = "Contributor for 3+ months"
field_permission = "Permission to Publish?"

# Load environment variables
load_dotenv()

# Set up Airtable client
airtable = airtable.Airtable(base_id, os.environ["AIRTABLE_API_KEY"])

# Get all records from the table
records = airtable.iterate(table_id)

# Create an empty list to store the data
data = []

# Loop through each record in the table
for record in records:
    # Get the "Full Name" field
    items = record["fields"]
    qualified = items.get(field_qualified, False)
    permission = items.get(field_permission, False)
    if not qualified or not permission:
        continue

    full_name = items.get(field_name, "")

    # Loop through each attachment in the "Image" field of the record
    attachments = items.get(field_image, [])
    file_name = slugify(full_name)

    # Check if there is at least one attachment
    if attachments:
        # Get the first attachment
        attachment = attachments[0]

        # Get the attachment URL
        attachment_url = attachment["url"]

        # Check if the folder exists
        if not os.path.exists(image_folder):
            # Create the folder
            os.makedirs(image_folder)

        # Download the attachment
        file_type = os.path.splitext(attachment["filename"])[1]
        file_path = os.path.join(image_folder, f"{file_name}{file_type}")
        response = requests.get(attachment_url)
        with open(file_path, "wb") as f:
            f.write(response.content)
        print(f"Downloaded attachment: {file_path}")

        # Add the data to the list
        #
        # "name": "Full Name",
        # "title": "Engineer",
        # "company": "co",
        # "image": "jpeg",
        # "projects": []
        #
        data.append(
            {
                "name": full_name,
                "title": items.get(field_title, ""),
                "organization": items.get(field_company, ""),
                "projects": items.get(field_projects, []),
                "image": f"/{file_path}",
            }
        )

# Check if the folder exists
if not os.path.exists(data_folder):
    # Create the folder
    os.makedirs(data_folder)

# Write the data to a JSON file
with open(os.path.join(data_folder, data_file), "w") as f:
    json.dump(data, f, indent=4)

print("Done!")
