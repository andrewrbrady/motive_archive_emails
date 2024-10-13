#!/bin/bash

update_index_with_titles() {
    local index_file="index.md"
    local email_dir="./email"
    local temp_file=$(mktemp)

    echo "Starting to process index file: $index_file"

    # Function to extract title from YAML front matter
    extract_title() {
        local file="$1"
        echo "Extracting title from file: $file"
        
        # Extract title from YAML front matter
        local title=$(sed -n '/^---$/,/^---$/p' "$file" | grep '^title:' | sed 's/^title: *//;s/^"//;s/"$//;s/^'"'"'//;s/'"'"'$//')
        
        echo "Extracted title: '$title'"
        
        if [ -z "$title" ]; then
            title=$(basename "$file" .md)
            echo "Title not found in YAML front matter, using filename: $title"
        else
            echo "Title found in YAML front matter: $title"
        fi
        echo "$title"
    }

    # Process the index file
    local processing_list=false
    while IFS= read -r line; do
        if [[ $line == "## Email List" ]]; then
            processing_list=true
            echo "$line" >> "$temp_file"
            echo "Found Email List header"
        elif [[ $processing_list == true && $line == "## "* ]]; then
            processing_list=false
            echo "$line" >> "$temp_file"
            echo "Finished processing Email List"
        elif [[ $processing_list == true && $line =~ ^\[.*\]\(\.\/email\/email-.*\.md\)$ ]]; then
            filename=$(echo "$line" | sed -n 's/.*](\(.*\))/\1/p')
            echo "Processing file: $filename"
            if [[ -f "$filename" ]]; then
                title=$(extract_title "$filename")
                echo "Final extracted title: '$title'"
                new_line="[$title]($filename)"
                echo "$new_line" >> "$temp_file"
                echo "Updated line: $new_line"
            else
                echo "$line" >> "$temp_file"
                echo "File not found: $filename"
            fi
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$index_file"

    # Replace the original file with the updated content
    mv "$temp_file" "$index_file"

    echo "Finished processing index file"
}

# Call the function
update_index_with_titles