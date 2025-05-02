#!/bin/bash

# Check that at least two arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 pattern_file target_file1 [target_file2 ... target_fileN]"
    exit 1
fi

pattern_file="$1"
shift

# Check that the pattern file exists
if [ ! -f "$pattern_file" ]; then
    echo "Pattern file not found: $pattern_file"
    exit 1
fi

# Loop through each target file to clean
for target_file in "$@"; do
    if [ ! -f "$target_file" ]; then
        echo "Target file not found: $target_file"
        continue
    fi

    # Create a temporary copy to modify
    tmpfile=$(mktemp)
    cp "$target_file" "$tmpfile"

    # Read each pattern line by line
    while IFS= read -r pattern || [ -n "$pattern" ]; do
        # Skip empty lines
        [ -z "$pattern" ] && continue

        # Delete all lines that contain the pattern
        # Escape characters that could break the sed regex
        sed -i "/$(printf '%s' "$pattern" | sed 's/[^^]/[&]/g; s/\^/\\^/g')/d" "$tmpfile"
    done < "$pattern_file"

    # Replace original file with the cleaned version
    mv "$tmpfile" "$target_file"
    echo "Cleaned: $target_file"
done
