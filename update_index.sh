#!/bin/bash

update_index_with_titles() {
    local index_file="index.md"
    local email_dir="./email"
    local temp_file=$(mktemp)

    # Function to extract title from YAML front matter
    extract_title() {
        local file="$1"
        local title=$(sed -n '/^---$/,/^---$/p' "$file" | grep '^title:' | sed 's/^title: *//;s/^"//;s/"$//')
        if [ -z "$title" ]; then
            title=$(basename "$file" .md)
        fi
        echo "$title"
    }

    # Copy content up to the email list header
    sed '/^## Email List/q' "$index_file" > "$temp_file"
    echo "## Email List" >> "$temp_file"

    # Process each email markdown file
    find "$email_dir" -name "email-*.md" | sort | while read -r file; do
        filename=$(basename "$file")
        title=$(extract_title "$file")
        echo "[$title](./${file#./})" >> "$temp_file"
    done

    # Append the rest of the original content
    sed -n '/^## About This Site/,$p' "$index_file" >> "$temp_file"

    # Replace the original file with the updated content
    mv "$temp_file" "$index_file"

    echo "Index file updated successfully with correct titles from YAML front matter!"
}

# Call the function
update_index_with_titles