#!/bin/bash

# Directory containing the template and where new files will be created
EMAIL_DIR="./email"

# Template file name
TEMPLATE_FILE="template.md"

# Script to update the index
UPDATE_SCRIPT="./update_index.sh"

# Check if the template file exists
if [ ! -f "$EMAIL_DIR/$TEMPLATE_FILE" ]; then
    echo "Error: Template file $EMAIL_DIR/$TEMPLATE_FILE not found."
    exit 1
fi

# Check if the update script exists
if [ ! -f "$UPDATE_SCRIPT" ]; then
    echo "Error: Update script $UPDATE_SCRIPT not found."
    exit 1
fi

# Generate the timestamp for the new file name
TIMESTAMP=$(date +"%y%m%d-%H%M%S")

# Create the new file name
NEW_FILE="email-$TIMESTAMP.md"

# Copy the template to the new file
cp "$EMAIL_DIR/$TEMPLATE_FILE" "$EMAIL_DIR/$NEW_FILE"

# Check if the copy was successful
if [ $? -eq 0 ]; then
    echo "New email file created: $EMAIL_DIR/$NEW_FILE"
else
    echo "Error: Failed to create new email file."
    exit 1
fi

# Run the update_index.sh script
echo "Updating index..."
if bash "$UPDATE_SCRIPT"; then
    echo "Index updated successfully."
else
    echo "Error: Failed to update index."
    exit 1
fi

# Optionally, open the new file in the default text editor
# Uncomment the following line if you want this functionality
# xdg-open "$EMAIL_DIR/$NEW_FILE" 2>/dev/null || open "$EMAIL_DIR/$NEW_FILE" 2>/dev/null || echo "File created, but couldn't open