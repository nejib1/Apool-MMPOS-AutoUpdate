#!/bin/bash

# Script for automatically checking and updating the apool miner in MMPOS.
# Author: Nejib BEN AHMED

OUTPUT_FILE="last_version.txt"
TARGET_DIR="."
CURRENT_DATE=$(date +%Y-%m-%d)  # Get today's date in YYYY-MM-DD format
LAST_MODIFIED_DATE=$(date -r "$OUTPUT_FILE" +%Y-%m-%d 2>/dev/null)

# If last_version.txt was not modified today, proceed
if [ "$LAST_MODIFIED_DATE" != "$CURRENT_DATE" ]; then
    URL="https://github.com/apool-io/apoolminer/releases/latest"

    # Fetch version from the <h1> tag
    VERSION=$(curl -sL $URL | grep -o '<h1[^>]*>v[0-9]\+\.[0-9]\+\.[0-9]\+' | sed 's/.*>v/v/')

    # If version is found and differs from last version, proceed
    if [ -n "$VERSION" ] && ! grep -q "$VERSION" "$OUTPUT_FILE" 2>/dev/null; then
        echo "$VERSION" > $OUTPUT_FILE

        # Download and extract the .tar.gz file if it exists
        FILE_URL="https://github.com/ddobreff/mmpos/releases/download/$VERSION/apoolminer-$VERSION.tar.gz"
        if curl --head --silent --fail "$FILE_URL" > /dev/null; then
            echo "Downloading $FILE_URL..."
            curl -L -o "apoolminer-$VERSION.tar.gz" "$FILE_URL" && \
            tar --strip-components=1 -xzf "apoolminer-$VERSION.tar.gz" -C "$TARGET_DIR" && \
            rm "apoolminer-$VERSION.tar.gz" && \
            echo "Files extracted..."
        else
            echo "File $FILE_URL does not exist."
        fi
    else
        echo "Version $VERSION is already up to date or not found."
    fi
else
    echo "Last version file was updated today. No action taken."
fi
