#!/bin/bash -l

SSHPASS=$(grep -E '^SSHPASS=' /etc/environment | cut -d= -f2)

# Your input file
sshpass -e sftp -oBatchMode=no -b - ocpuser@204.13.180.17 << EOF > /home/gitlab-runner/mysql-scripts/dev_remote_files_list.txt
   cd in1-dev
   ls -lrt
   bye
EOF

remote_filelist="dev_remote_files_list.txt"
input_file="dev_clean_sftp_output.txt"

# Temporary file to store updated contents
temp_file="temp_file.txt"
output_file="difference_gt_7_days.txt"

# Current date in the "bbddYY" format
current_date=$(date +"%b %d %Y")

# Function to calculate the date difference
datediff() {
    d1=$(date -d "$1" +%s)
    d2=$(date -d "$2" +%s)
    echo $(( (d1 - d2) / 86400 ))  # Calculate the difference in days
}

grep -v "sftp>" "$remote_filelist" > "$input_file"

while IFS= read -r line; do
    date_field=$(echo "$line" | awk '{print $6" "$7" "$8}')
    formatted_date=$(date -d "$date_field" +"%b %d %Y")

    # Calculate the date difference
    date_difference=$(datediff "$current_date" "$formatted_date")

    file_name=$(echo "$line" | awk '{print $NF}')

    # Print the difference between the file date and the current date
    echo "File: $file_name, Date Difference: $date_difference days"
    # If the difference is greater than 7 days, write the row to the output file
    if [ "$date_difference" -gt 7 ]; then
        file_name=$(echo "$line" | awk '{print $NF}')
        echo "$file_name" >> "$output_file"
    fi
done < "$input_file"

if [ -s "$output_file" ]; then
    while IFS= read -r file; do
        echo "Removing $file"
        sshpass -e sftp -oBatchMode=no -b - ocpuser@204.13.180.17 << EOF
        cd in1-dev
        rm "$file"
        bye
EOF
        echo "Removed file: $file"
    done < "$output_file"
else
    echo "No files to remove."
fi

rm -rf "$output_file"
rm -rf "$temp_file"
