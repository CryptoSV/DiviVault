#!/bin/bash

# This script analyzes vault rewards and reports statistics. It's used with New Relic for monitoring.

# Configuration
log_file="/home/admin/logs/allVaultRewards.log"
divi_cli="/home/admin/divi-3.0.0/bin/divi-cli"

# Current date and time in epoch format
current_time=$(date +"%s")

# Calculate timestamps for various intervals
start_of_today=$(date -d 'today 00:00:00' +"%s")
twenty_four_hours_ago=$(date -d '24 hours ago' +"%s")
ninety_days_ago=$(date -d '90 days ago' +"%s") # Corrected spelling
yesterday_same_time=$(date -d 'yesterday 00:00:00' +"%s")

# Function to count logs in a given time range
count_logs() {
    awk -v start="$1" -v end="$2" -F, '$4 >= start && $4 <= end {count++} END {print count+0}' "$log_file"
}

# Use the function to count logs for specific intervals
count_ninety_days=$(count_logs "$ninety_days_ago" "$current_time")
count_last_24_hours=$(count_logs "$twenty_four_hours_ago" "$current_time")
count_today=$(count_logs "$start_of_today" "$current_time")
count_yesterday=$(count_logs "$yesterday_same_time" "$start_of_today")

# Total number of rewards
numRewards=$(wc -l "$log_file" | awk '{print $1}')

# Extract month counts
current_month=$(date +'%m')
previous_month=$(date -d "$(date +%Y-%m-01) -1 day" +'%m')

# Initialize associative array for monthly counts
declare -A counts

# Read the log file line by line
while IFS= read -r line; do
    month=$(echo "$line" | cut -d'-' -f2)
    ((counts[$month]++))
done < "$log_file"

# Retrieve counts for current and previous months
current_counts=${counts[$current_month]:-0}
previous_counts=${counts[$previous_month]:-0}

# Extract confirmations from the last transaction
last_confirmations=$("$divi_cli" listtransactions | jq '.[-1].confirmations')

# Calculate the time since the last reward
last_epoch_date=$(awk -F ', ' '{print $NF}' "$log_file" | tail -n 1)
seconds_passed=$((current_time - last_epoch_date))
hours=$((seconds_passed / 3600))
minutes=$((seconds_passed % 3600 / 60))

# Output stats for New Relic integration - comment if testing
echo "$numRewards $previous_counts $current_counts $count_last_24_hours $count_ninety_days $count_yesterday $count_today $last_confirmations $hours $minutes"

# Reporting - uncomment for testing only. The New Relic integration won't work with these uncommented.
#echo "Total Rewards: $numRewards"
#echo "Rewards in the Last 90 Days: $count_ninety_days"
#echo "Rewards in the Last 24 Hours: $count_last_24_hours"
#echo "Rewards Today: $count_today"
#echo "Rewards Yesterday: $count_yesterday"
#echo "Current Month's Rewards: $current_counts"
#echo "Previous Month's Rewards: $previous_counts"
#echo "Last Confirmation Count: ${last_confirmations:-0}"
#echo "Time Since Last Reward: ${hours}h ${minutes}m"
