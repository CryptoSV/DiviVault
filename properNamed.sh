#!/bin/bash

# This script takes a number as input and outputs a the same number and it's proper suffix: st, nd, rd, or th.

# Check if a number is provided
if [[ -z "$1" ]]; then
  echo "Please provide a number."
  exit 1
fi

# Get the number
num=$1

# Determine the last two digits (useful for numbers like 111th, 112th, 113th)
last_two_digits=$(echo "$num" | rev | cut -c 1-2 | rev)

# Determine the last digit
last_digit=$(echo "$num" | rev | cut -c 1 | rev)

# Check the suffix
if [[ $last_two_digits -ge 11 && $last_two_digits -le 13 ]]; then
  suffix="th"
else
  case $last_digit in
    1) suffix="st";;
    2) suffix="nd";;
    3) suffix="rd";;
    *) suffix="th";;
  esac
fi

# Output the number with its suffix
echo "${num}${suffix}"
