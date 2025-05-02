#!/bin/bash 
set -e
FORCE=0
if [ "$1" == "-f" ]; then
    FORCE=1
fi

# Check if the 'hoi4' process is running
if pgrep -x "hoi4" > /dev/null && [ "$FORCE" -ne 1 ]; then
    echo "Cannot clean the log while 'hoi4' is running."
    echo "Cleaning the error log while the game is running prevents it from logging properly."
    echo "Use '-f' to force the clean anyway (at your own risk)."
    exit 1
fi
# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define the path to the pattern file (in the same directory as this script)
PATTERN_FILE="$SCRIPT_DIR/hoi4patterns.txt"

# Call clean_lines.sh using the correct paths
"$SCRIPT_DIR/cleaner.sh" "$PATTERN_FILE" ~/.local/share/Paradox\ Interactive/Hearts\ of\ Iron\ IV/logs/error.log
