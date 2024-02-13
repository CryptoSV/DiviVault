#!/bin/bash

# Scripts:
echo "This section:"
echo " -Asks you for your AWS SNS ARN and Chainz CryptoID key"
echo " -Downloads two notification scripts"
echo "  Location: /home/admin/scripts"
echo "  1. current.sh"
echo "  2. allVaultRewards.sh"
echo " -Updates both file permissions"
echo " -Updates the files with your AWS SNS ARN, Region, and CryptoID key"
read -n 1 -s -r -p "Press spacebar to continue..."

wget -P /home/admin/scripts https://raw.githubusercontent.com/CryptoSV/DiviVault/main/current.sh
wget -P /home/admin/scripts https://raw.githubusercontent.com/CryptoSV/DiviVault/main/allVaultRewards.sh

chmod +x /home/admin/scripts/notification/*

echo ""

# Ask the user for the full ARN
read -p "Enter the full AWS SNS ARN (e.g., arn:aws:sns:us-west-2:992382426593:VaultNotification): " full_arn

# Use cut to extract the region
# ARN format: arn:partition:service:region:account-id:resource
region=$(echo "$full_arn" | cut -d':' -f4)

# Ask the user for the CryptoID
read -p "Enter your Chainz CryptoID key: " cryptoID_key


# The path to the auto.sh file that needs to be updated
script_all="/home/admin/scripts/allVaultRewards.sh"
script_cur="/home/admin/scripts/current.sh"

# Check if all.sh exists
if [ ! -f "$script_all" ]; then
    echo "Error: $script_all does not exist."
    exit 1
fi

# Check if cur.sh exists
if [ ! -f "$script_cur" ]; then
    echo "Error: $script_cur does not exist."
    exit 1
fi


# All needs SNS ARN, Region, and CryptoID key
# Use sed to replace [Your SNS ARN] with the user's full_arn in script_all.sh
sed -i "s|\[Your SNS ARN\]|$full_arn|g" "$script_all"

# Use sed to replace [Your AWS Region] with the user's region in script_all.sh
sed -i "s|\[Your AWS Region\]|$region|g" "$script_all"

# Use sed to replace [Your AWS Region] with the user's region in script_all.sh
sed -i "s|\[Your CryptoID key\]|$cryptoID_key|g" "$script_all"

echo "script_all.sh has been updated with your SNS ARN, region, and CryptoID key."

# Cur needs SNS ARN and Region only
# Use sed to replace [Your SNS ARN] with the user's full_arn in script_all.sh
sed -i "s|\[Your SNS ARN\]|$full_arn|g" "$script_cur"

# Use sed to replace [Your AWS Region] with the user's region in script_all.sh
sed -i "s|\[Your AWS Region\]|$region|g" "$script_cur"

echo "script_cur.sh has been updated with your ARN and region."
