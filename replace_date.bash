#!/bin/bash

# Check if arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <directory> <search_string> <replacement_string>"
    exit 1
fi

dir="$1"
search="$2"
replace="$3"

# Check if directory exists
if [ ! -d "$dir" ]; then
    echo "Error: Directory '$dir' does not exist."
    exit 1
fi

# Escape special characters for sed
escaped_search=$(printf '%s\n' "$search" | sed -e 's/[\/&]/\\&/g')
escaped_replace=$(printf '%s\n' "$replace" | sed -e 's/[\/&]/\\&/g')

# Replace in file contents
echo "Replacing '$search' with '$replace' in file contents..."
find "$dir" -type f -exec sed -i "s/$escaped_search/$escaped_replace/g" {} +

# Replace in filenames
echo "Replacing '$search' with '$replace' in filenames..."
find "$dir" -depth -name "*$search*" | while read -r file; do
    newname=$(echo "$file" | sed "s/$escaped_search/$escaped_replace/g")
    if [ "$file" != "$newname" ]; then
        mv -v "$file" "$newname"
    fi
done

echo "Replacement complete."
