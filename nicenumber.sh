#!/bin/bash

# This script works with the getCurrentVaultValue.sh script.

   # nicenumber--Given a number, shows it in comma-separated form. Expects DD
   #   (decimal point delimiter) and TD (thousands delimiter) to be instantiated.
   #   Instantiates nicenum or, if a second arg is specified, the output is
   #   echoed to stdout.

   nicenumber()
   {
      # Note that we assume that '.' is the decimal separator in the INPUT value
      # to this script. The decimal separator in the output value is '.'

     integer=$(echo $1 | cut -d. -f1)        # Left of the decimal
     decimal=$(echo $1 | cut -d. -f2)        # Right of the decimal

     # Check if number has more than the integer part.
     if [ "$decimal" != "$1" ]; then
        # There's a fractional part, so let's include it.
        result="${DD:= '.'}$decimal"
     fi

     thousands=$integer

     while [ $thousands -gt 999 ]; do
          remainder=$(($thousands % 1000))    # Three least significant digits

          # We need 'remainder' to be three digits. Do we need to add zeros?
          while [ ${#remainder} -lt 3 ] ; do  # Force leading zeros
              remainder="0$remainder"
          done

          result="${TD:=","}${remainder}${result}"    # Builds right to left
          thousands=$(($thousands / 1000))    # To left of remainder, if any
     done

     nicenum="${thousands}${result}"
     if [ ! -z $2 ] ; then
        echo $nicenum
     fi
   }

   DD="."  # Decimal point delimiter, to separate whole and fractional values
   TD=","  # Add thousands separator using (,) to separate every three digits

   # Input validation
   if [ $# -eq 0 ] ; then
     echo "Please provide an integer value"
     exit 0
   fi

   # BEGIN MAIN SCRIPT
   # =================

   nicenumber $1 1   # Second arg forces nicenumber to 'echo' output.

   exit 0
   
