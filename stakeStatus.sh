#!/bin/bash

## Get the staking status

divi_cli="/home/admin/divi-3.0.0/bin/divi-cli"

# Run the Get Staking Status command and load the output into an array
readarray -t arr < <("$divi_cli" getstakingstatus | jq -r '.validtime, .haveconnections, .walletunlocked, .mintablecoins, .enoughcoins, .mnsync, ."staking status"')

echo "${arr[0]} ${arr[1]} ${arr[2]} ${arr[3]} ${arr[4]} ${arr[5]} ${arr[6]}"
