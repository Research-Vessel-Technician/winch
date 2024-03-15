#!/bin/bash

# Asksfor the folder path to look into
read -p "Enter the folder path: " folder_path

# Check if the folder exists
if [ ! -d "$folder_path" ]; then
    echo "Folder not found: $folder_path"
    exit 1
fi

# Ask for the threshold value, anything higher than this value in column 4 will return the whole row
read -p "Enter the threshold value: " threshold

# Ask for the output filename, all rows will be saved into a new file
read -p "Enter the output filename: " output_filename

# Initialize the output file with a header
echo "File,Column1,Column2,Column3,Column4,Column5,Column6,Column7,Column8,Column9,Column10" > "$output_filename"

# Loop through each file in the folder that has a .3PS_WINCH extension, can change to match different file structure
for filename in "$folder_path"/*.3PS_WINCH; do
    if [ -f "$filename" ]; then
        echo "Processing file: $filename"

        # Initialize variables to keep track of the maximum value in column 4 for each file
        max_value=""
        max_row=""

        # Read the file, assuming comma (,) as the delimiter
        while IFS=',' read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10; do
            # Trim leading spaces from column 4 value, if your data doesn't have leading spaces, I'm not sure what would happen?
            col4_trimmed=$(echo "$col4" | sed -e 's/^[[:space:]]*//')

            # Check if the trimmed value in column 4 is numeric and above the threshold
            if [[ "$col4_trimmed" =~ ^[0-9]+(\.[0-9]+)?$ ]] && (( $(echo "$col4_trimmed > $threshold" | bc -l) )); then
                # If max_value is empty or the current value is greater than max_value
                if [ -z "$max_value" ] || (( $(echo "$col4_trimmed > $max_value" | bc -l) )); then
                    max_value="$col4_trimmed"
                    max_row="$filename,$col1,$col2,$col3,$col4,$col5,$col6,$col7,$col8,$col9,$col10"
                fi
            fi
        done < "$filename"

        # Print the entire row with the greatest value in column 4 above the threshold for each file
        if [ -n "$max_row" ]; then
            echo "$max_row" >> "$output_filename"
        fi
    fi
done
