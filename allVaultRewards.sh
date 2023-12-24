#!/bin/bash

# This scripts looks for new vault rewards and sends a notification to AWS SNS with all the details of the reward.
# This script requires the properNamed.sh script.

## Variables

# You *MUST* update this AWS SNS ARN variable.
sns_arn="arn:aws:sns:us-east-2:516864295231:MyVaultReward"

# You *MUST* make sure you have the correct AWS Region. You can see the region in the ARN above.
aws_region="us-east-2"

# Define the log path
log_path="/home/admin/logs/allVaultRewards.log"

# Define the URL to get the current price
url="https://chainz.cryptoid.info/divi/api.dws?key=0555db334b09&q=ticker.usd"

# Fetch the transactions in JSON format
output=$( /home/admin/divi-3.0.0/bin/divi-cli listtransactions )

# Parse each "stake_reward" entry, check confirmations, and convert the time to the specified format
echo "$output" | jq -c '.[] | select(.category=="stake_reward" and .confirmations > 0) | {time: .time, amount: .amount}' | while read -r line; do
    epoch_time=$(echo $line | jq '.time')
    amount=$(echo $line | jq '.amount' | awk -F'.' '{print $1}')

    time_formatted=$(date -d @"$epoch_time" '+%Y-%m-%d %H:%M:%S')
    dPrice=$(printf "%.6f\n" $(curl -s $url))
    log_entry="${time_formatted}, ${amount}, ${dPrice}, ${epoch_time}"

    # Check if the block_time already exists in the log file
    if ! grep -q "$epoch_time" "$log_path"; then
        echo "$log_entry" >> "$log_path"
        numRewards=$(wc -l /home/admin/logs/allVaultRewards.log | awk '{print $1}')
        named=$(/home/admin/scripts/properNamed.sh ${numRewards})
        echo "${time_formatted}, ${amount}, ${dPrice}, ${epoch_time}"
        aws sns publish --topic-arn $sns_arn --message " ${named} vault reward of ${amount} at: ${time_formatted} for ${dPrice}" --region $aws_region
    fi
done
