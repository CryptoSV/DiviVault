#!/bin/bash

# Run the command and capture the JSON output
json_output=$(/home/admin/divi-3.0.0/bin/divi-cli getcoinavailability true)

# Extract the value using jq
value=$(echo "$json_output" | jq -r '.Stakable.AllVaults[0].value')

# Format the value with thousands commas
formatedValue=$(/home/admin/scripts/nicenumber.sh $value)

echo "$formatedValue $value"
