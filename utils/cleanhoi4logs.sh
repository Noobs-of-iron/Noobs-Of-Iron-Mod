#!/bin/bash 
set -ex
# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define the path to the pattern file (in the same directory as this script)
PATTERN_FILE="$SCRIPT_DIR/hoi4patterns.txt"

# Call clean_lines.sh using the correct paths
"$SCRIPT_DIR/cleaner.sh" "$PATTERN_FILE" ~/.local/share/Paradox\ Interactive/Hearts\ of\ Iron\ IV/logs/error.log
