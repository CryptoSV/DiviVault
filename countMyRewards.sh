#!/bin/bash

# Log file path
log_file="/home/admin/logs/allVaultRewards.log"

# Current date and time in epoch format
current_time=$(date +"%s")

# Calculate the timestamp for the start of today in epoch format
start_of_today=$(date -d 'today 00:00:00' +"%s")

# Calculate the timestamp for 24 hours ago in epoch format
twenty_four_hours_ago=$(date -d '24 hours ago' +"%s")

# Calculate the timestamp for 90 days ago in epoch format
ninty_days_ago=$(date -d '2160 hours ago' +"%s")

# Count the number of logs between now and 90 days ago
count_ninty_days=$(awk -v start="$ninty_days_ago" -v end="$current_time" -F, \
                        '$4 >= start && $4 <= end {count++} END {print count}' "$log_file")

# Calculate the timestamp for yesterday at the same time in epoch format
yesterday_same_time=$(date -d 'yesterday 00:00:00' +"%s")

# Count the number of logs between the two timestamps
count_last_24_hours=$(awk -v start="$twenty_four_hours_ago" -v end="$current_time" -F, \
                      '$4 >= start && $4 <= end {count++} END {print count}' "$log_file")

# Count the number of logs that occurred today
count_today=$(awk -v start="$start_of_today" -v end="$current_time" -F, \
              '$4 >= start && $4 <= end {count++} END {print count}' "$log_file")

# Count the number of logs that occurred yesterday at the same time
count_yesterday=$(awk -v start="$yesterday_same_time" -v end="$start_of_today" -F, \
                  '$4 >= start && $4 < end {count++} END {print count}' "$log_file")

numRewards=$(wc -l /home/admin/logs/allVaultRewards.log | awk '{print $1}')

current_month=$(date +'%m')
previous_month=$(date -d 'last month' +'%m')

# Generate JSON data using divi-cli listtransactions
json_data=$(/home/admin/divi-3.0.0/bin/divi-cli listtransactions)

# Use jq to extract the last item's confirmations
last_confirmations=$(echo "$json_data" | jq '.[-1].confirmations')

# Initialize an associative array to store the counts for each month
declare -A counts

# Read the log file line by line
while IFS= read -r line; do
    # Extract the month from the log entry
    month=$(echo "$line" | awk '{print $1}' | cut -d'-' -f2)

    # Increment the count for the corresponding month in the array
    ((counts[$month]++))
done < "$log_file"

# Store the counts for the current and previous months
current_counts=${counts[$current_month]}
previous_counts=${counts[$previous_month]}

## This section figures out the amount of hours and minutes that have passed since the last reward
# Extract the epoch date from the last line of the log file
last_epoch_date=$(tail -n 1 "$log_file" | awk -F ', ' '{print $NF}')

# Get the current epoch date
current_epoch_date=$(date +%s)

# Calculate the difference in seconds
seconds_passed=$((current_epoch_date - last_epoch_date))

# Calculate hours and minutes
hours=$((seconds_passed / 3600))
minutes=$(( (seconds_passed % 3600) / 60 ))

# Check for NULL and replace with 0
if [ -z "$current_counts" ]; then current_counts=0; fi
if [ -z "$previous_counts" ]; then previous_counts=0; fi
if [ -z "$count_ninty_days" ]; then count_ninty_days=0; fi
if [ -z "$count_last_24_hours" ]; then count_last_24_hours=0; fi
if [ -z "$count_today" ]; then count_today=0; fi
if [ -z "$count_yesterday" ]; then count_yesterday=0; fi
if [ -z "$last_confirmations" ]; then last_confirmations=0; fi

echo "$numRewards $previous_counts $current_counts $count_last_24_hours $count_ninty_days $count_yesterday $count_today $last_confirmations $hours $minutes"
