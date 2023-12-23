#!/bin/bash

## Setup variables
current_date=$(date)
log_path_file="/home/admin/logs/stakingStatus.log"

# You *MUST* update this AWS SNS ARN variable.
sns_arn="arn:aws:sns:us-east-2:556767245239:MyVaultReward"

# You *MUST* make sure you have the correct AWS Region. You can see the region in the ARN above.
aws_region="us-east-2"

# Change if you wish
error_message="ERROR staking status is false"

## Check the staking status

# Run the Get Staking Status command and load the output into an array
readarray -t arr < <(/home/admin/divi-3.0.0/bin/divi-cli getstakingstatus | jq -r '.validtime, .haveconnections, .walletunlocked, .mintablecoins, .enoughcoins, .mnsync, ."staking status"')

# Check the output for the statking status
if [ "${arr[6]}" == "false" ]; then
    # There is an issue -> send status to the log file and send an AWS SNS message
    echo "Staking status is ${arr[6]}"
    echo "$current_date $error_message - validtime: ${arr[0]}, haveconnections: ${arr[1]}, walletunlocked: ${arr[2]}, mintablecoins: ${arr[3]}, enoughcoins: ${arr[4]}, mnsync: ${arr[5]}, staking status: ${arr[6]}" >> $log_path_file
    aws sns publish --topic-arn $sns_arn --message "$current_date $error_message - validtime: ${arr[0]}, haveconnections: ${arr[1]}, walletunlocked: ${arr[2]}, mintablecoins: ${arr[3]}, enoughcoins: ${arr[4]}, mnsync: ${arr[5]}, staking status: ${arr[6]}" --region $aws_region
else
    # Staking status is okay
    echo "Staking status is ${arr[6]}"
fi
