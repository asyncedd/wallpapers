#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <wildcard_pattern> <output_directory>"
    exit 1
fi

wildcard_pattern="$1"
output_directory="$2"

# Check if the output directory exists
if [ ! -d "$output_directory" ]; then
    echo "Error: Output directory does not exist."
    exit 1
fi

# Check if ImageMagick's 'convert' command is installed
if ! command -v convert &>/dev/null; then
    echo "Error: ImageMagick 'convert' command not found. Please install ImageMagick."
    exit 1
fi

# Use the wildcard pattern within the loop to find matching files
shopt -s nullglob # Handle the case when no files are found
for file in $wildcard_pattern; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        extension="${filename##*.}"
        filename="${filename%.*}"
        output_file="$output_directory/$filename.png"

        # Convert the file to PNG and move it to the output directory
        convert "$file" "$output_file"

        # Remove the original file
        rm "$file"

        echo "Converted and moved $file to $output_file"
    else
        echo "Skipping non-file entry: $file"
    fi
done

echo "Conversion and removal completed successfully."
