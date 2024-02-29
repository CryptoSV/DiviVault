#!/bin/bash

# This scripts parses the last "stake_reward" entry from listtransactions and checks the confirmations. If they are greater than 20 (about 20 minutes), then get current coin availabile and report it to New Relic.

# Get the JSON output from this command
output=$(/home/admin/divi-3.0.0/bin/divi-cli listtransactions)

# Load the last entry
last_entry=$(echo "$output" | jq '.[] | select(.category == "stake_reward" and .confirmations > 20) | .[-1]')

echo "Last entry: $last_entry"

# If last_entry is not empty, echo "done"
if [ ! -z "$last_entry" ]; then
	# Run the command and capture the JSON output
	json_output=$(/home/admin/divi-3.0.0/bin/divi-cli getcoinavailability true)

	# Extract the value using jq
	value=$(echo "$json_output" | jq -r '.Stakable.AllVaults[0].value')

	# Format the value with thousands commas
	formatedValue=$(/home/admin/scripts/nicenumber.sh $value)

	echo "$formatedValue $value"
fi
