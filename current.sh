#!/bin/bash

# This script checks the staking status and, if not properly running, will send an AWS SNS notification.
# It will also send an AWS SNS notification when the status is normal.

# Setup variables
current_date=$(date)
divi_cli="/home/admin/divi-3.0.0/bin/divi-cli"
log_file="/home/admin/logs/stakingStatus.log"
sns_arn="[Your SNS ARN]"  # Update this with your actual SNS ARN
aws_region="[Your AWS Region]"  # Update this with your actual AWS region

## Functions

# Function to send AWS SNS Notification
send_sns_notification() {
    local message=$1
    aws sns publish --topic-arn $sns_arn --message "$message" --region $aws_region
}

# Function to log and send notification
log_and_notify() {
    local message="$current_date $1 - validtime: ${arr[0]}, haveconnections: ${arr[1]}, walletunlocked: ${arr[2]}, mintablecoins: ${arr[3]}, enoughcoins: ${arr[4]}, mnsync: ${arr[5]}, staking status: ${arr[6]}"
    echo "$message" >> $log_file
    send_sns_notification "$message"
}

# Check if the log file is empty
if [ ! -s "$log_file" ]; then
    echo "Log file is empty. Initializing log file."
    # Initialize the log file 
    echo "$current_date Log file created." >> $log_file
fi

# Get staking status
readarray -t arr < <("$divi_cli" getstakingstatus | jq -r '.validtime, .haveconnections, .walletunlocked, .mintablecoins, .enoughcoins, .mnsync, ."staking status"')

# Check last log entry for "ERROR"
last_row_contains_error=$(tail -n 1 $log_file | grep -q "ERROR"; echo $?)

# Check staking status

if [ "${arr[6]}" == "false" ]; then
    if [ "$last_row_contains_error" -ne 0 ]; then
        # New issue detected
        log_and_notify "ERROR staking vault not running correctly"
    else
        echo "Ongoing issue detected. Staking status is still false."
    fi
else
    if [ "$last_row_contains_error" -eq 0 ]; then
        # Issue resolved
        log_and_notify "UPDATE staking vault is now running correctly"
    else
        echo "Staking status is true. No action required."
    fi
fi
