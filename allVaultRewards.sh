#!/bin/bash

# This script looks for new vault rewards and sends a notification to Amazon SNS with all the details of the reward.

# Configuration Variables
sns_arn="[Your SNS ARN]"  # Update this with your actual SNS ARN
aws_region="[Your AWS Region]"  # Update this with your actual AWS region
cryptoid_key="[Your CryptoID key]"  # Update with your Chainz CryptoID key

divi_cli="/home/admin/divi-3.0.0/bin/divi-cli"
log_path="/home/admin/logs/allVaultRewards.log"
price_url="https://chainz.cryptoid.info/divi/api.dws?key=${cryptoid_key}&q=ticker.usd"

# Initialize reward count
reward_count=0

## Functions

# Fetches the current DIVI price
fetch_current_price() {
    printf "%.6f\n" "$(curl -s "$price_url")"
}

# Publishes a message to Amazon SNS
publish_to_sns() {
    local message=$1
    aws sns publish --topic-arn "$sns_arn" --message "$message" --region "$aws_region"
}

# Determines the correct ordinal suffix for a number
get_number_suffix() {
    local num=$1
    local last_two_digits=$((num % 100))
    local last_digit=$((num % 10))

    if [[ $last_two_digits -ge 11 && $last_two_digits -le 13 ]]; then
        echo "th"
    else
        case $last_digit in
            1) echo "st";;
            2) echo "nd";;
            3) echo "rd";;
            *) echo "th";;
        esac
    fi
}

# Main Process
output=$("$divi_cli" listtransactions)

# Parse each "stake_reward" entry, check confirmations and convert the time to the specified format
while read -r line; do
    epoch_time=$(jq -r '.time' <<< "$line")
    amount=$(jq -r '.amount' <<< "$line" | awk -F'.' '{print $1}')
    time_formatted=$(date -d @"$epoch_time" '+%Y-%m-%d %H:%M:%S')
    dPrice=$(fetch_current_price)

    if ! grep -q "$epoch_time" "$log_path"; then
        echo "${time_formatted}, ${amount}, ${dPrice}, ${epoch_time}" >> "$log_path"
        ((reward_count++))  # Increment the reward count
        numRewards=$(wc -l "$log_path" | awk '{print $1}')
        suffix=$(get_number_suffix "$numRewards")
        publish_to_sns "${numRewards}${suffix} vault reward of ${amount} at: ${time_formatted} for ${dPrice}"
    fi
done < <(echo "$output" | jq -c '.[] | select((.category=="stake_reward" or .category=="lottery") and .confirmations > 0)')

# Output the total number of new rewards found
echo "Total new rewards found: $reward_count"
