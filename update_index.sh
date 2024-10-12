#!/bin/bash

# File to update
index_file="index.md"

# Directory to search
email_dir="./email"

# Find all email files
email_files=$(find "$email_dir" -type f -name "email-??????-??????.md" | sort)

# Read the current content of the index file
content=$(cat "$index_file")

# Find the line number where we should start inserting new links
insert_line=$(grep -n "^Here are some of my Markdown files:" "$index_file" | cut -d: -f1)
insert_line=$((insert_line + 1))

# Temporary file for the updated content
temp_file=$(mktemp)

# Copy the content up to the insert line to the temp file
head -n "$insert_line" "$index_file" > "$temp_file"

# Process each email file
for file in $email_files; do
    # Extract just the filename
    filename=$(basename "$file")
    
    # Check if the file is already in the index
    if ! grep -q "$filename" "$index_file"; then
        # If not, add it to the temp file
        echo "[${filename%.md}](./email/$filename)" >> "$temp_file"
    fi
done

# Append the rest of the original content
tail -n +$((insert_line + 1)) "$index_file" >> "$temp_file"

# Replace the original file with the updated content
mv "$temp_file" "$index_file"

echo "Index file updated successfully!"