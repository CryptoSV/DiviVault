#!/bin/bash

# This script checks the last transaction from the listtransactions command, checks to make sure
#  it's either a stake_reward or lottery, and if it has confirmations > waitForConfirmations. If so,
#  then it gets the current staked value, formats it, and outputs it to work with the
#  New Relic integrations.d file: flexVaultCurrentValue.yml

# Change this if the getcoinavailability command returns a number that is lower than it should be. You'll see this if
#  the New Relic History chart has drops that spike down. This happens while the stake_reward or lottery is validated.
#  Once validated, the correct number is returned. Each confirmation is about one minute.
waitForConfirmations=20

# Get JSON data from the listtransactions and load it into an array
IFS=$'\n' read -r -d '' -a entries < <(/home/admin/divi-3.0.0/bin/divi-cli listtransactions | jq -c '.[]' && printf '\0')

# Get the index of the last element in the array
last_index=$(( ${#entries[@]} - 1 ))

# Get the last entry from the array
last_entry=${entries[$last_index]}

# Extract confirmations from the last entry
confirmations=$(echo "$last_entry" | jq -r '.confirmations')

# Check if confirmations are greater than waitForConfirmations
if (( confirmations > $waitForConfirmations )); then
    # Run the command and capture the JSON output
    json_output=$(/home/admin/divi-3.0.0/bin/divi-cli getcoinavailability true)

    # Extract the value using jq
    value=$(echo "$json_output" | jq -r '.Stakable.AllVaults[0].value')

    # Format the value with thousands commas
    formatedValue=$(/home/admin/scripts/nicenumber.sh $value)

    echo "$formatedValue $value"
fi
