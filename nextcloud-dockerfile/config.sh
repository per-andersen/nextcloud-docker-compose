#!/bin/bash

# File to edit
file_path="/usr/local/etc/php/php.ini-development"

# Value to search for and replace with
search_value=";opcache.memory_consumption=128"
replace_value=";opcache.memory_consumption=256"

# Check if the file exists
if [ ! -f "$file_path" ]; then
    echo "Error: File $file_path does not exist."
    exit 1
fi

# Check if the search value exists in the file
if grep -q "$search_value" "$file_path"; then
    # Replace the search value with the replace value
    sed -i "s/$search_value/$replace_value/" "$file_path"
    echo "Value replaced successfully."
else
    echo "Error: $search_value not found in $file_path"
    exit 1
fi